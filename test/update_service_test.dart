import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketforge/features/update/update_service.dart';

/// Fake-адаптер: манифест + APK-байты + платформенный канал через
/// исключение (не Android).
class UpdateAdapter implements HttpClientAdapter {
  UpdateAdapter(this.manifest);

  final Map<String, Object?> manifest;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (options.uri.path.endsWith('appcast.json')) {
      return _json(manifest);
    }
    if (options.uri.path.endsWith('.apk')) {
      return ResponseBody(
        Stream.value(
          Uint8List.fromList(
            List<int>.generate(1024, (i) => i % 256),
          ),
        ),
        200,
        headers: {
          Headers.contentLengthHeader: ['1024'],
          Headers.contentTypeHeader: [
            'application/vnd.android.package-archive',
          ],
        },
      );
    }
    return ResponseBody.fromString('{}', 404);
  }

  ResponseBody _json(Map<String, Object?> body) => ResponseBody.fromString(
        jsonEncode(body),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('semverCompare', () {
    test('v-префикс и недостающие компоненты', () {
      expect(semverCompare('1.0.1', '1.0.0'), 1);
      expect(semverCompare('1.0', '1.0.0'), 0);
      expect(semverCompare('v2.0.0', '1.9.9'), 1);
      expect(semverCompare('1.2.3', '1.2.4'), -1);
      expect(semverCompare('0.1.0', '0.1.0'), 0);
    });
  });

  group('UpdateService', () {
    UpdateService service(UpdateAdapter adapter) {
      final dio = Dio()..httpClientAdapter = adapter;
      return UpdateService(
        dio: dio,
        channel: const MethodChannel('pocketforge/update_test'),
      );
    }

    test('checkForUpdate: есть обновление', () async {
      final svc = service(UpdateAdapter({
        'version': '1.2.0',
        'apkUrl': 'https://x.example/pf-1.2.0.apk',
        'notes': 'release notes',
      }));
      final r = await svc.checkForUpdate(currentVersion: '1.1.5');
      expect(r.isUpdate, isTrue);
      expect(r.version, '1.2.0');
      expect(r.notes, 'release notes');
    });

    test('checkForUpdate: версия совпадает — не обновление', () async {
      final svc = service(UpdateAdapter({
        'version': '1.1.5',
        'apkUrl': 'https://x.example/pf.apk',
        'notes': '',
      }));
      final r = await svc.checkForUpdate(currentVersion: '1.1.5');
      expect(r.isUpdate, isFalse);
    });

    test('downloadApk: пишет файл и сообщает прогресс', () async {
      final svc = service(UpdateAdapter({
        'version': '1.0.0',
        'apkUrl': 'https://x.example/app/pf-test.apk',
        'notes': '',
      }));
      final dir = await Directory.systemTemp.createTemp('pf_update_test');
      addTearDown(() => dir.delete(recursive: true));
      var progressCalls = 0;
      final path = await svc.downloadApk(
        'https://x.example/app/pf-test.apk',
        dir: dir,
        onProgress: (received, total) {
          progressCalls++;
          expect(total, 1024);
        },
      );
      expect(progressCalls, 1);
      final f = File(path);
      expect(f.existsSync(), isTrue);
      expect(f.lengthSync(), 1024);
    });

    test('checkForUpdate: apkSha256 из манифеста нормализуется', () async {
      final svc = service(UpdateAdapter({
        'version': '1.2.0',
        'apkUrl': 'https://x.example/pf-1.2.0.apk',
        'apkSha256': 'ABCDEF0123',
        'notes': '',
      }));
      final r = await svc.checkForUpdate(currentVersion: '1.1.5');
      expect(r.apkSha256, 'abcdef0123');
    });

    test('checkForUpdate: без apkSha256 — null (проверка не выполняется)',
        () async {
      final svc = service(UpdateAdapter({
        'version': '1.2.0',
        'apkUrl': 'https://x.example/pf-1.2.0.apk',
        'notes': '',
      }));
      final r = await svc.checkForUpdate(currentVersion: '1.1.5');
      expect(r.apkSha256, isNull);
    });

    test('downloadApk: sha256 совпал — файл принимается', () async {
      final svc = service(UpdateAdapter({
        'version': '1.0.0',
        'apkUrl': 'https://x.example/app/pf-test.apk',
        'notes': '',
      }));
      final dir = await Directory.systemTemp.createTemp('pf_update_test');
      addTearDown(() => dir.delete(recursive: true));
      final expected =
          sha256.convert(List<int>.generate(1024, (i) => i % 256)).toString();
      final path = await svc.downloadApk(
        'https://x.example/app/pf-test.apk',
        dir: dir,
        expectedSha256: expected,
      );
      expect(File(path).lengthSync(), 1024);
    });

    test('downloadApk: битый sha256 — повторная попытка и исключение',
        () async {
      final svc = service(UpdateAdapter({
        'version': '1.0.0',
        'apkUrl': 'https://x.example/app/pf-test.apk',
        'notes': '',
      }));
      final dir = await Directory.systemTemp.createTemp('pf_update_test');
      addTearDown(() => dir.delete(recursive: true));
      await expectLater(
        svc.downloadApk(
          'https://x.example/app/pf-test.apk',
          dir: dir,
          expectedSha256: '00' * 32,
        ),
        throwsException,
      );
    });

    test('currentVersion без платформы — unknown', () async {
      final svc = service(UpdateAdapter({}));
      // Метод-канал недоступен на хосте → MissingPluginException → unknown.
      expect(await svc.currentVersion(), 'unknown');
    });
  });
}
