import 'package:flutter_test/flutter_test.dart';
import 'package:pocketforge/features/git/git_parsers.dart';

void main() {
  group('parseHead', () {
    test('ветка', () {
      final (ref, detached) = parseHead('ref: refs/heads/main\n');
      expect(ref, 'refs/heads/main');
      expect(detached, isFalse);
    });

    test('detached', () {
      final (ref, detached) = parseHead('abc123def456\n');
      expect(ref, 'abc123def456');
      expect(detached, isTrue);
    });
  });

  group('parsePackedRefs', () {
    test('refs, комментарии и peeled-строки', () {
      final refs = parsePackedRefs('''
# pack-refs with: peeled fully-peeled sorted
<oid-a> refs/heads/main
<oid-b> refs/heads/dev
^<peeled-annotated>
<oid-c> refs/remotes/origin/main
''');
      expect(refs['refs/heads/main'], '<oid-a>');
      expect(refs['refs/heads/dev'], '<oid-b>');
      expect(refs['refs/remotes/origin/main'], '<oid-c>');
      expect(refs.containsKey('^<peeled-annotated>'), isFalse);
      expect(refs, hasLength(3));
    });
  });

  group('parseReflog', () {
    test('строки reflog → записи, свежие сверху', () {
      const log = '''
0000000 aaaaaaa1 Ivan Petrov <ivan@example.com> 1700000000 +0000\tclone: from https://github.com/x/y.git
aaaaaaa1 bbbbbbb2 Ivan Petrov <ivan@example.com> 1700000100 +0000\tcommit (initial): init
bbbbbbb2 ccccccc3 Ivan Petrov <ivan@example.com> 1700000200 +0000\tcommit: fix readme
''';
      final entries = parseReflog(log);
      expect(entries, hasLength(3));
      expect(entries[0].oid, 'ccccccc3');
      expect(entries[0].message, 'commit: fix readme');
      expect(entries[0].timestamp, 1700000200);
      expect(entries[0].author, contains('Ivan'));
      expect(entries.last.message, 'clone: from https://github.com/x/y.git');
    });

    test('limit обрезает старые', () {
      final sb = StringBuffer();
      for (var i = 0; i < 10; i++) {
        sb.writeln(
          'o${i}n n${i}n A <a@x> ${1700000000 + i} +0000\tcommit: c$i',
        );
      }
      final entries = parseReflog(sb.toString(), limit: 3);
      expect(entries, hasLength(3));
      expect(entries.first.message, 'commit: c9');
      expect(entries.last.message, 'commit: c7');
    });
  });

  group('mergeBranches', () {
    test('packed + loose объединяются, current по headRef', () {
      final result = mergeBranches(
        loose: [
          const GitBranch(name: 'feature', oid: 'fff1', current: false),
        ],
        packed: {
          'refs/heads/main': 'aaa1',
          'refs/heads/dev': 'bbb2',
        },
        headRef: 'refs/heads/dev',
      );
      expect(result.map((b) => b.name), ['dev', 'feature', 'main']);
      expect(result.firstWhere((b) => b.name == 'dev').current, isTrue);
      expect(result.firstWhere((b) => b.name == 'main').oid, 'aaa1');
      expect(result.firstWhere((b) => b.name == 'feature').oid, 'fff1');
    });
  });
}
