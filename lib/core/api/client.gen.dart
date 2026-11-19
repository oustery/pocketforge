// GENERATED - DO NOT EDIT BY HAND
// Сгенерировано scripts/gen_api_client.py из спецификации opencode.
import 'package:dio/dio.dart';

import 'models.gen.dart';

/// Типизированные методы всех операций opencode serve.
class OpenCodeApiGen {
  /// Создаёт клиент поверх готового [Dio].
  OpenCodeApiGen(this._dio);

  final Dio _dio;

  /// `PUT /auth/{providerID}` — Set auth credentials
  Future<bool> authSet({
    required String providerID,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<String>(
      '/auth/{providerID}'.replaceAll(
        '{providerID}',
        Uri.encodeComponent(providerID.toString()),
      ),
      data: body,
      options: Options(method: 'PUT', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `DELETE /auth/{providerID}` — Remove auth credentials
  Future<bool> authRemove({required String providerID}) async {
    final res = await _dio.request<String>(
      '/auth/{providerID}'.replaceAll(
        '{providerID}',
        Uri.encodeComponent(providerID.toString()),
      ),
      options: Options(method: 'DELETE', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `POST /log` — Write log
  Future<bool> appLog({
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<String>(
      '/log',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `POST /experimental/control-plane/move-session` — Move session
  Future<dynamic> experimentalControlPlaneMoveSession({
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/experimental/control-plane/move-session',
      data: body,
      options: Options(method: 'POST'),
    );
    return res.data;
  }

  /// `GET /global/health` — Get health
  Future<GlobalHealthResponse> globalHealth() async {
    final res = await _dio.request<Object?>(
      '/global/health',
      options: Options(method: 'GET'),
    );
    return GlobalHealthResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /global/event` — Get global events
  Future<Stream<List<int>>> globalEvent() async {
    final res = await _dio.get<ResponseBody>(
      '/global/event',
      options: Options(method: 'GET', responseType: ResponseType.stream),
    );
    return res.data!.stream;
  }

  /// `GET /global/config` — Get global configuration
  Future<Config> globalConfigGet() async {
    final res = await _dio.request<Object?>(
      '/global/config',
      options: Options(method: 'GET'),
    );
    return Config.fromJson(res.data! as Map<String, Object?>);
  }

  /// `PATCH /global/config` — Update global configuration
  Future<Config> globalConfigUpdate({Config? body}) async {
    final res = await _dio.request<Object?>(
      '/global/config',
      data: body?.toJson(),
      options: Options(method: 'PATCH'),
    );
    return Config.fromJson(res.data! as Map<String, Object?>);
  }

  /// `POST /global/dispose` — Dispose instance
  Future<bool> globalDispose() async {
    final res = await _dio.request<String>(
      '/global/dispose',
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `POST /global/upgrade` — Upgrade opencode
  Future<dynamic> globalUpgrade({Map<String, Object?>? body}) async {
    final res = await _dio.request<Object?>(
      '/global/upgrade',
      data: body,
      options: Options(method: 'POST'),
    );
    return res.data;
  }

  /// `GET /event` — Subscribe to events
  Future<Stream<List<int>>> eventSubscribe({
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.get<ResponseBody>(
      '/event',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET', responseType: ResponseType.stream),
    );
    return res.data!.stream;
  }

  /// `GET /config` — Get configuration
  Future<Config> configGet({String? directory, String? workspace}) async {
    final res = await _dio.request<Object?>(
      '/config',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return Config.fromJson(res.data! as Map<String, Object?>);
  }

  /// `PATCH /config` — Update configuration
  Future<Config> configUpdate({
    String? directory,
    String? workspace,
    Config? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/config',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body?.toJson(),
      options: Options(method: 'PATCH'),
    );
    return Config.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /config/providers` — List config providers
  Future<ConfigProvidersResponse> configProviders({
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<Object?>(
      '/config/providers',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return ConfigProvidersResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /experimental/capabilities` — Get experimental capabilities
  Future<ExperimentalCapabilities> experimentalCapabilitiesGet({
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<Object?>(
      '/experimental/capabilities',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return ExperimentalCapabilities.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /experimental/console` — Get active Console provider metadata
  Future<ConsoleState> experimentalConsoleGet({
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<Object?>(
      '/experimental/console',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return ConsoleState.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /experimental/console/orgs` — List switchable Console orgs
  Future<ExperimentalConsoleListOrgsResponse> experimentalConsoleListOrgs({
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<Object?>(
      '/experimental/console/orgs',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return ExperimentalConsoleListOrgsResponse.fromJson(
      res.data! as Map<String, Object?>,
    );
  }

  /// `POST /experimental/console/switch` — Switch active Console org
  Future<bool> experimentalConsoleSwitchOrg({
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<String>(
      '/experimental/console/switch',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `GET /experimental/tool` — List tools
  Future<ToolListItem> toolList({
    String? directory,
    String? workspace,
    required String provider,
    required String model,
  }) async {
    final res = await _dio.request<Object?>(
      '/experimental/tool',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
        if (provider != null) 'provider': provider,
        if (model != null) 'model': model,
      },
      options: Options(method: 'GET'),
    );
    return ToolListItem.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /experimental/tool/ids` — List tool IDs
  Future<String> toolIds({String? directory, String? workspace}) async {
    final res = await _dio.request<String>(
      '/experimental/tool/ids',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET', responseType: ResponseType.plain),
    );
    return res.data! as String;
  }

  /// `GET /experimental/worktree` — List worktrees
  Future<List<String>> worktreeList({
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<List<dynamic>>(
      '/experimental/worktree',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return (res.data! as List).map((e) => e as String).toList();
  }

  /// `POST /experimental/worktree` — Create worktree
  Future<Worktree> worktreeCreate({
    String? directory,
    String? workspace,
    WorktreeCreateInput? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/experimental/worktree',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body?.toJson(),
      options: Options(method: 'POST'),
    );
    return Worktree.fromJson(res.data! as Map<String, Object?>);
  }

  /// `DELETE /experimental/worktree` — Remove worktree
  Future<bool> worktreeRemove({
    String? directory,
    String? workspace,
    WorktreeRemoveInput? body,
  }) async {
    final res = await _dio.request<String>(
      '/experimental/worktree',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body?.toJson(),
      options: Options(method: 'DELETE', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `POST /experimental/worktree/reset` — Reset worktree
  Future<bool> worktreeReset({
    String? directory,
    String? workspace,
    WorktreeResetInput? body,
  }) async {
    final res = await _dio.request<String>(
      '/experimental/worktree/reset',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body?.toJson(),
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `GET /experimental/session` — List sessions
  Future<List<GlobalSession>> experimentalSessionList({
    String? directory,
    String? workspace,
    String? roots,
    String? start,
    String? cursor,
    String? search,
    String? limit,
    String? archived,
  }) async {
    final res = await _dio.request<List<dynamic>>(
      '/experimental/session',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
        if (roots != null) 'roots': roots,
        if (start != null) 'start': start,
        if (cursor != null) 'cursor': cursor,
        if (search != null) 'search': search,
        if (limit != null) 'limit': limit,
        if (archived != null) 'archived': archived,
      },
      options: Options(method: 'GET'),
    );
    return (res.data! as List)
        .map((e) => GlobalSession.fromJson(e as Map<String, Object?>))
        .toList();
  }

  /// `POST /experimental/session/{sessionID}/background` — Background subagents
  Future<bool> experimentalSessionBackground({
    required String sessionID,
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<String>(
      '/experimental/session/{sessionID}/background'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `GET /experimental/resource` — Get MCP resources
  Future<ExperimentalResourceListResponse> experimentalResourceList({
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<Object?>(
      '/experimental/resource',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return ExperimentalResourceListResponse.fromJson(
      res.data! as Map<String, Object?>,
    );
  }

  /// `GET /find` — Find text
  Future<List<Map<String, dynamic>>> findText({
    String? directory,
    String? workspace,
    required String pattern,
  }) async {
    final res = await _dio.request<List<dynamic>>(
      '/find',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
        if (pattern != null) 'pattern': pattern,
      },
      options: Options(method: 'GET'),
    );
    return (res.data! as List).map((e) => e as Map<String, Object?>).toList();
  }

  /// `GET /find/file` — Find files
  Future<List<String>> findFiles({
    String? directory,
    String? workspace,
    required String query,
    String? dirs,
    String? type,
    String? limit,
  }) async {
    final res = await _dio.request<List<dynamic>>(
      '/find/file',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
        if (query != null) 'query': query,
        if (dirs != null) 'dirs': dirs,
        if (type != null) 'type': type,
        if (limit != null) 'limit': limit,
      },
      options: Options(method: 'GET'),
    );
    return (res.data! as List).map((e) => e as String).toList();
  }

  /// `GET /find/symbol` — Find symbols
  Future<List<Symbol>> findSymbols({
    String? directory,
    String? workspace,
    required String query,
  }) async {
    final res = await _dio.request<List<dynamic>>(
      '/find/symbol',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
        if (query != null) 'query': query,
      },
      options: Options(method: 'GET'),
    );
    return (res.data! as List)
        .map((e) => Symbol.fromJson(e as Map<String, Object?>))
        .toList();
  }

  /// `GET /file` — List files
  Future<List<FileNode>> fileList({
    String? directory,
    String? workspace,
    required String path,
  }) async {
    final res = await _dio.request<List<dynamic>>(
      '/file',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
        if (path != null) 'path': path,
      },
      options: Options(method: 'GET'),
    );
    return (res.data! as List)
        .map((e) => FileNode.fromJson(e as Map<String, Object?>))
        .toList();
  }

  /// `GET /file/content` — Read file
  Future<FileContent> fileRead({
    String? directory,
    String? workspace,
    required String path,
  }) async {
    final res = await _dio.request<Object?>(
      '/file/content',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
        if (path != null) 'path': path,
      },
      options: Options(method: 'GET'),
    );
    return FileContent.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /file/status` — Get file status
  Future<List<File>> fileStatus({String? directory, String? workspace}) async {
    final res = await _dio.request<List<dynamic>>(
      '/file/status',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return (res.data! as List)
        .map((e) => File.fromJson(e as Map<String, Object?>))
        .toList();
  }

  /// `POST /instance/dispose` — Dispose instance
  Future<bool> instanceDispose({String? directory, String? workspace}) async {
    final res = await _dio.request<String>(
      '/instance/dispose',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `GET /path` — Get paths
  Future<Path> pathGet({String? directory, String? workspace}) async {
    final res = await _dio.request<Object?>(
      '/path',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return Path.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /vcs` — Get VCS info
  Future<VcsInfo> vcsGet({String? directory, String? workspace}) async {
    final res = await _dio.request<Object?>(
      '/vcs',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return VcsInfo.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /vcs/status` — Get VCS status
  Future<List<VcsFileStatus>> vcsStatus({
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<List<dynamic>>(
      '/vcs/status',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return (res.data! as List)
        .map((e) => VcsFileStatus.fromJson(e as Map<String, Object?>))
        .toList();
  }

  /// `GET /vcs/diff` — Get VCS diff
  Future<List<VcsFileDiff>> vcsDiff({
    String? directory,
    String? workspace,
    required String mode,
    String? context,
  }) async {
    final res = await _dio.request<List<dynamic>>(
      '/vcs/diff',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
        if (mode != null) 'mode': mode,
        if (context != null) 'context': context,
      },
      options: Options(method: 'GET'),
    );
    return (res.data! as List)
        .map((e) => VcsFileDiff.fromJson(e as Map<String, Object?>))
        .toList();
  }

  /// `GET /vcs/diff/raw` — Get raw VCS diff
  Future<String> vcsDiffRaw({String? directory, String? workspace}) async {
    final res = await _dio.request<String>(
      '/vcs/diff/raw',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET', responseType: ResponseType.plain),
    );
    return res.data! as String;
  }

  /// `POST /vcs/apply` — Apply VCS patch
  Future<VcsApplyResponse> vcsApply({
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/vcs/apply',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST'),
    );
    return VcsApplyResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /command` — List commands
  Future<List<Command>> commandList({
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<List<dynamic>>(
      '/command',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return (res.data! as List)
        .map((e) => Command.fromJson(e as Map<String, Object?>))
        .toList();
  }

  /// `GET /agent` — List agents
  Future<List<Agent>> appAgents({String? directory, String? workspace}) async {
    final res = await _dio.request<List<dynamic>>(
      '/agent',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return (res.data! as List)
        .map((e) => Agent.fromJson(e as Map<String, Object?>))
        .toList();
  }

  /// `GET /skill` — List skills
  Future<List<Map<String, dynamic>>> appSkills({
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<List<dynamic>>(
      '/skill',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return (res.data! as List).map((e) => e as Map<String, Object?>).toList();
  }

  /// `GET /lsp` — Get LSP status
  Future<List<LSPStatus>> lspStatus({
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<List<dynamic>>(
      '/lsp',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return (res.data! as List)
        .map((e) => LSPStatus.fromJson(e as Map<String, Object?>))
        .toList();
  }

  /// `GET /formatter` — Get formatter status
  Future<List<FormatterStatus>> formatterStatus({
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<List<dynamic>>(
      '/formatter',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return (res.data! as List)
        .map((e) => FormatterStatus.fromJson(e as Map<String, Object?>))
        .toList();
  }

  /// `GET /mcp` — Get MCP status
  Future<McpStatusResponse> mcpStatus({
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<Object?>(
      '/mcp',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return McpStatusResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `POST /mcp` — Add MCP server
  Future<McpAddResponse> mcpAdd({
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/mcp',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST'),
    );
    return McpAddResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `POST /mcp/{name}/auth` — Start MCP OAuth
  Future<McpAuthStartResponse> mcpAuthStart({
    required String name,
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<Object?>(
      '/mcp/{name}/auth'.replaceAll(
        '{name}',
        Uri.encodeComponent(name.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'POST'),
    );
    return McpAuthStartResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `DELETE /mcp/{name}/auth` — Remove MCP OAuth
  Future<McpAuthRemoveResponse> mcpAuthRemove({
    required String name,
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<Object?>(
      '/mcp/{name}/auth'.replaceAll(
        '{name}',
        Uri.encodeComponent(name.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'DELETE'),
    );
    return McpAuthRemoveResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `POST /mcp/{name}/auth/callback` — Complete MCP OAuth
  Future<dynamic> mcpAuthCallback({
    required String name,
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/mcp/{name}/auth/callback'.replaceAll(
        '{name}',
        Uri.encodeComponent(name.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST'),
    );
    return res.data;
  }

  /// `POST /mcp/{name}/auth/authenticate` — Authenticate MCP OAuth
  Future<dynamic> mcpAuthAuthenticate({
    required String name,
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<Object?>(
      '/mcp/{name}/auth/authenticate'.replaceAll(
        '{name}',
        Uri.encodeComponent(name.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'POST'),
    );
    return res.data;
  }

  /// `POST /mcp/{name}/connect` — mcp.connect
  Future<bool> mcpConnect({
    required String name,
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<String>(
      '/mcp/{name}/connect'.replaceAll(
        '{name}',
        Uri.encodeComponent(name.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `POST /mcp/{name}/disconnect` — mcp.disconnect
  Future<bool> mcpDisconnect({
    required String name,
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<String>(
      '/mcp/{name}/disconnect'.replaceAll(
        '{name}',
        Uri.encodeComponent(name.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `GET /project` — List all projects
  Future<List<Project>> projectList({
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<List<dynamic>>(
      '/project',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return (res.data! as List)
        .map((e) => Project.fromJson(e as Map<String, Object?>))
        .toList();
  }

  /// `GET /project/current` — Get current project
  Future<Project> projectCurrent({String? directory, String? workspace}) async {
    final res = await _dio.request<Object?>(
      '/project/current',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return Project.fromJson(res.data! as Map<String, Object?>);
  }

  /// `POST /project/git/init` — Initialize git repository
  Future<Project> projectInitGit({String? directory, String? workspace}) async {
    final res = await _dio.request<Object?>(
      '/project/git/init',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'POST'),
    );
    return Project.fromJson(res.data! as Map<String, Object?>);
  }

  /// `PATCH /project/{projectID}` — Update project
  Future<Project> projectUpdate({
    required String projectID,
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/project/{projectID}'.replaceAll(
        '{projectID}',
        Uri.encodeComponent(projectID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'PATCH'),
    );
    return Project.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /project/{projectID}/directories` — List project directories
  Future<dynamic> projectDirectories({
    required String projectID,
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<Object?>(
      '/project/{projectID}/directories'.replaceAll(
        '{projectID}',
        Uri.encodeComponent(projectID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return res.data;
  }

  /// `POST /experimental/project/{projectID}/copy/generate-name` — Generate project copy name
  Future<ExperimentalProjectCopyGenerateNameResponse>
  experimentalProjectCopyGenerateName({
    required String projectID,
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/experimental/project/{projectID}/copy/generate-name'.replaceAll(
        '{projectID}',
        Uri.encodeComponent(projectID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST'),
    );
    return ExperimentalProjectCopyGenerateNameResponse.fromJson(
      res.data! as Map<String, Object?>,
    );
  }

  /// `GET /pty/shells` — List available shells
  Future<List<Map<String, dynamic>>> ptyShells({
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<List<dynamic>>(
      '/pty/shells',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return (res.data! as List).map((e) => e as Map<String, Object?>).toList();
  }

  /// `GET /pty` — List PTY sessions
  Future<List<Pty>> ptyList({String? directory, String? workspace}) async {
    final res = await _dio.request<List<dynamic>>(
      '/pty',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return (res.data! as List)
        .map((e) => Pty.fromJson(e as Map<String, Object?>))
        .toList();
  }

  /// `POST /pty` — Create PTY session
  Future<Pty> ptyCreate({
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/pty',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST'),
    );
    return Pty.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /pty/{ptyID}` — Get PTY session
  Future<Pty> ptyGet({
    required String ptyID,
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<Object?>(
      '/pty/{ptyID}'.replaceAll(
        '{ptyID}',
        Uri.encodeComponent(ptyID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return Pty.fromJson(res.data! as Map<String, Object?>);
  }

  /// `PUT /pty/{ptyID}` — Update PTY session
  Future<Pty> ptyUpdate({
    required String ptyID,
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/pty/{ptyID}'.replaceAll(
        '{ptyID}',
        Uri.encodeComponent(ptyID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'PUT'),
    );
    return Pty.fromJson(res.data! as Map<String, Object?>);
  }

  /// `DELETE /pty/{ptyID}` — Remove PTY session
  Future<bool> ptyRemove({
    required String ptyID,
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<String>(
      '/pty/{ptyID}'.replaceAll(
        '{ptyID}',
        Uri.encodeComponent(ptyID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'DELETE', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `POST /pty/{ptyID}/connect-token` — Create PTY WebSocket token
  Future<PtyTicketConnectToken> ptyConnectToken({
    required String ptyID,
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<Object?>(
      '/pty/{ptyID}/connect-token'.replaceAll(
        '{ptyID}',
        Uri.encodeComponent(ptyID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'POST'),
    );
    return PtyTicketConnectToken.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /question` — List pending questions
  Future<List<QuestionRequest>> questionList({
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<List<dynamic>>(
      '/question',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return (res.data! as List)
        .map((e) => QuestionRequest.fromJson(e as Map<String, Object?>))
        .toList();
  }

  /// `POST /question/{requestID}/reply` — Reply to question request
  Future<bool> questionReply({
    required String requestID,
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<String>(
      '/question/{requestID}/reply'.replaceAll(
        '{requestID}',
        Uri.encodeComponent(requestID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `POST /question/{requestID}/reject` — Reject question request
  Future<bool> questionReject({
    required String requestID,
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<String>(
      '/question/{requestID}/reject'.replaceAll(
        '{requestID}',
        Uri.encodeComponent(requestID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `GET /permission` — List pending permissions
  Future<List<PermissionRequest>> permissionList({
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<List<dynamic>>(
      '/permission',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return (res.data! as List)
        .map((e) => PermissionRequest.fromJson(e as Map<String, Object?>))
        .toList();
  }

  /// `POST /permission/{requestID}/reply` — Respond to permission request
  Future<bool> permissionReply({
    required String requestID,
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<String>(
      '/permission/{requestID}/reply'.replaceAll(
        '{requestID}',
        Uri.encodeComponent(requestID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `GET /provider` — List providers
  Future<ProviderListResponse> providerList({
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<Object?>(
      '/provider',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return ProviderListResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /provider/auth` — Get provider auth methods
  Future<ProviderAuthResponse> providerAuth({
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<Object?>(
      '/provider/auth',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return ProviderAuthResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `POST /provider/{providerID}/oauth/authorize` — Start OAuth authorization
  Future<ProviderAuthAuthorization> providerOauthAuthorize({
    required String providerID,
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/provider/{providerID}/oauth/authorize'.replaceAll(
        '{providerID}',
        Uri.encodeComponent(providerID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST'),
    );
    return ProviderAuthAuthorization.fromJson(
      res.data! as Map<String, Object?>,
    );
  }

  /// `POST /provider/{providerID}/oauth/callback` — Handle OAuth callback
  Future<bool> providerOauthCallback({
    required String providerID,
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<String>(
      '/provider/{providerID}/oauth/callback'.replaceAll(
        '{providerID}',
        Uri.encodeComponent(providerID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `GET /session` — List sessions
  Future<List<Session>> sessionList({
    String? directory,
    String? workspace,
    String? scope,
    String? path,
    String? roots,
    String? start,
    String? search,
    String? limit,
  }) async {
    final res = await _dio.request<List<dynamic>>(
      '/session',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
        if (scope != null) 'scope': scope,
        if (path != null) 'path': path,
        if (roots != null) 'roots': roots,
        if (start != null) 'start': start,
        if (search != null) 'search': search,
        if (limit != null) 'limit': limit,
      },
      options: Options(method: 'GET'),
    );
    return (res.data! as List)
        .map((e) => Session.fromJson(e as Map<String, Object?>))
        .toList();
  }

  /// `POST /session` — Create session
  Future<Session> sessionCreate({
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/session',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST'),
    );
    return Session.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /session/status` — Get session status
  Future<SessionStatusResponse> sessionStatus({
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<Object?>(
      '/session/status',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return SessionStatusResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /session/{sessionID}` — Get session
  Future<Session> sessionGet({
    required String sessionID,
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<Object?>(
      '/session/{sessionID}'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return Session.fromJson(res.data! as Map<String, Object?>);
  }

  /// `DELETE /session/{sessionID}` — Delete session
  Future<bool> sessionDelete({
    required String sessionID,
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<String>(
      '/session/{sessionID}'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'DELETE', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `PATCH /session/{sessionID}` — Update session
  Future<Session> sessionUpdate({
    required String sessionID,
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/session/{sessionID}'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'PATCH'),
    );
    return Session.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /session/{sessionID}/children` — Get session children
  Future<List<Session>> sessionChildren({
    required String sessionID,
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<List<dynamic>>(
      '/session/{sessionID}/children'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return (res.data! as List)
        .map((e) => Session.fromJson(e as Map<String, Object?>))
        .toList();
  }

  /// `GET /session/{sessionID}/todo` — Get session todos
  Future<List<Todo>> sessionTodo({
    required String sessionID,
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<List<dynamic>>(
      '/session/{sessionID}/todo'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return (res.data! as List)
        .map((e) => Todo.fromJson(e as Map<String, Object?>))
        .toList();
  }

  /// `GET /session/{sessionID}/diff` — Get message diff
  Future<List<SnapshotFileDiff>> sessionDiff({
    required String sessionID,
    String? directory,
    String? workspace,
    String? messageID,
  }) async {
    final res = await _dio.request<List<dynamic>>(
      '/session/{sessionID}/diff'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
        if (messageID != null) 'messageID': messageID,
      },
      options: Options(method: 'GET'),
    );
    return (res.data! as List)
        .map((e) => SnapshotFileDiff.fromJson(e as Map<String, Object?>))
        .toList();
  }

  /// `GET /session/{sessionID}/message` — Get session messages
  Future<List<Map<String, dynamic>>> sessionMessages({
    required String sessionID,
    String? directory,
    String? workspace,
    String? limit,
    String? before,
  }) async {
    final res = await _dio.request<List<dynamic>>(
      '/session/{sessionID}/message'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
        if (limit != null) 'limit': limit,
        if (before != null) 'before': before,
      },
      options: Options(method: 'GET'),
    );
    return (res.data! as List).map((e) => e as Map<String, Object?>).toList();
  }

  /// `POST /session/{sessionID}/message` — Send message
  Future<SessionPromptResponse> sessionPrompt({
    required String sessionID,
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/session/{sessionID}/message'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST'),
    );
    return SessionPromptResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /session/{sessionID}/message/{messageID}` — Get message
  Future<SessionMessageResponse> sessionMessage({
    required String sessionID,
    required String messageID,
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<Object?>(
      '/session/{sessionID}/message/{messageID}'
          .replaceAll('{sessionID}', Uri.encodeComponent(sessionID.toString()))
          .replaceAll('{messageID}', Uri.encodeComponent(messageID.toString())),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return SessionMessageResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `DELETE /session/{sessionID}/message/{messageID}` — Delete message
  Future<bool> sessionDeleteMessage({
    required String sessionID,
    required String messageID,
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<String>(
      '/session/{sessionID}/message/{messageID}'
          .replaceAll('{sessionID}', Uri.encodeComponent(sessionID.toString()))
          .replaceAll('{messageID}', Uri.encodeComponent(messageID.toString())),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'DELETE', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `POST /session/{sessionID}/fork` — Fork session
  Future<Session> sessionFork({
    required String sessionID,
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/session/{sessionID}/fork'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST'),
    );
    return Session.fromJson(res.data! as Map<String, Object?>);
  }

  /// `POST /session/{sessionID}/abort` — Abort session
  Future<bool> sessionAbort({
    required String sessionID,
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<String>(
      '/session/{sessionID}/abort'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `POST /session/{sessionID}/init` — Initialize session
  Future<bool> sessionInit({
    required String sessionID,
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<String>(
      '/session/{sessionID}/init'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `POST /session/{sessionID}/share` — Share session
  Future<Session> sessionShare({
    required String sessionID,
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<Object?>(
      '/session/{sessionID}/share'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'POST'),
    );
    return Session.fromJson(res.data! as Map<String, Object?>);
  }

  /// `DELETE /session/{sessionID}/share` — Unshare session
  Future<Session> sessionUnshare({
    required String sessionID,
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<Object?>(
      '/session/{sessionID}/share'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'DELETE'),
    );
    return Session.fromJson(res.data! as Map<String, Object?>);
  }

  /// `POST /session/{sessionID}/summarize` — Summarize session
  Future<bool> sessionSummarize({
    required String sessionID,
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<String>(
      '/session/{sessionID}/summarize'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `POST /session/{sessionID}/prompt_async` — Send async message
  Future<dynamic> sessionPromptAsync({
    required String sessionID,
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/session/{sessionID}/prompt_async'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST'),
    );
    return res.data;
  }

  /// `POST /session/{sessionID}/command` — Send command
  Future<SessionCommandResponse> sessionCommand({
    required String sessionID,
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/session/{sessionID}/command'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST'),
    );
    return SessionCommandResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `POST /session/{sessionID}/shell` — Run shell command
  Future<SessionShellResponse> sessionShell({
    required String sessionID,
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/session/{sessionID}/shell'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST'),
    );
    return SessionShellResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `POST /session/{sessionID}/revert` — Revert message
  Future<Session> sessionRevert({
    required String sessionID,
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/session/{sessionID}/revert'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST'),
    );
    return Session.fromJson(res.data! as Map<String, Object?>);
  }

  /// `POST /session/{sessionID}/unrevert` — Restore reverted messages
  Future<Session> sessionUnrevert({
    required String sessionID,
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<Object?>(
      '/session/{sessionID}/unrevert'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'POST'),
    );
    return Session.fromJson(res.data! as Map<String, Object?>);
  }

  /// `POST /session/{sessionID}/permissions/{permissionID}` — Respond to permission
  Future<bool> permissionRespond({
    required String sessionID,
    required String permissionID,
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<String>(
      '/session/{sessionID}/permissions/{permissionID}'
          .replaceAll('{sessionID}', Uri.encodeComponent(sessionID.toString()))
          .replaceAll(
            '{permissionID}',
            Uri.encodeComponent(permissionID.toString()),
          ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `DELETE /session/{sessionID}/message/{messageID}/part/{partID}` — part.delete
  Future<bool> partDelete({
    required String sessionID,
    required String messageID,
    required String partID,
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<String>(
      '/session/{sessionID}/message/{messageID}/part/{partID}'
          .replaceAll('{sessionID}', Uri.encodeComponent(sessionID.toString()))
          .replaceAll('{messageID}', Uri.encodeComponent(messageID.toString()))
          .replaceAll('{partID}', Uri.encodeComponent(partID.toString())),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'DELETE', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `PATCH /session/{sessionID}/message/{messageID}/part/{partID}` — part.update
  Future<dynamic> partUpdate({
    required String sessionID,
    required String messageID,
    required String partID,
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/session/{sessionID}/message/{messageID}/part/{partID}'
          .replaceAll('{sessionID}', Uri.encodeComponent(sessionID.toString()))
          .replaceAll('{messageID}', Uri.encodeComponent(messageID.toString()))
          .replaceAll('{partID}', Uri.encodeComponent(partID.toString())),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'PATCH'),
    );
    return res.data;
  }

  /// `POST /sync/start` — Start workspace sync
  Future<bool> syncStart({String? directory, String? workspace}) async {
    final res = await _dio.request<String>(
      '/sync/start',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `POST /sync/replay` — Replay sync events
  Future<SyncReplayResponse> syncReplay({
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/sync/replay',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST'),
    );
    return SyncReplayResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `POST /sync/steal` — Steal session into workspace
  Future<SyncStealResponse> syncSteal({
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/sync/steal',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST'),
    );
    return SyncStealResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `POST /sync/history` — List sync events
  Future<List<Map<String, dynamic>>> syncHistoryList({
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<List<dynamic>>(
      '/sync/history',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST'),
    );
    return (res.data! as List).map((e) => e as Map<String, Object?>).toList();
  }

  /// `POST /tui/append-prompt` — Append TUI prompt
  Future<bool> tuiAppendPrompt({
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<String>(
      '/tui/append-prompt',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `POST /tui/open-help` — Open help dialog
  Future<bool> tuiOpenHelp({String? directory, String? workspace}) async {
    final res = await _dio.request<String>(
      '/tui/open-help',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `POST /tui/open-sessions` — Open sessions dialog
  Future<bool> tuiOpenSessions({String? directory, String? workspace}) async {
    final res = await _dio.request<String>(
      '/tui/open-sessions',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `POST /tui/open-themes` — Open themes dialog
  Future<bool> tuiOpenThemes({String? directory, String? workspace}) async {
    final res = await _dio.request<String>(
      '/tui/open-themes',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `POST /tui/open-models` — Open models dialog
  Future<bool> tuiOpenModels({String? directory, String? workspace}) async {
    final res = await _dio.request<String>(
      '/tui/open-models',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `POST /tui/submit-prompt` — Submit TUI prompt
  Future<bool> tuiSubmitPrompt({String? directory, String? workspace}) async {
    final res = await _dio.request<String>(
      '/tui/submit-prompt',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `POST /tui/clear-prompt` — Clear TUI prompt
  Future<bool> tuiClearPrompt({String? directory, String? workspace}) async {
    final res = await _dio.request<String>(
      '/tui/clear-prompt',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `POST /tui/execute-command` — Execute TUI command
  Future<bool> tuiExecuteCommand({
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<String>(
      '/tui/execute-command',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `POST /tui/show-toast` — Show TUI toast
  Future<bool> tuiShowToast({
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<String>(
      '/tui/show-toast',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `POST /tui/publish` — Publish TUI event
  Future<bool> tuiPublish({
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<String>(
      '/tui/publish',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `POST /tui/select-session` — Select session
  Future<bool> tuiSelectSession({
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<String>(
      '/tui/select-session',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `GET /tui/control/next` — Get next TUI request
  Future<TuiControlNextResponse> tuiControlNext({
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<Object?>(
      '/tui/control/next',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return TuiControlNextResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `POST /tui/control/response` — Submit TUI response
  Future<bool> tuiControlResponse({
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<String>(
      '/tui/control/response',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `GET /experimental/workspace/adapter` — List workspace adapters
  Future<List<Map<String, dynamic>>> experimentalWorkspaceAdapterList({
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<List<dynamic>>(
      '/experimental/workspace/adapter',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return (res.data! as List).map((e) => e as Map<String, Object?>).toList();
  }

  /// `GET /experimental/workspace` — List workspaces
  Future<List<Workspace>> experimentalWorkspaceList({
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<List<dynamic>>(
      '/experimental/workspace',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return (res.data! as List)
        .map((e) => Workspace.fromJson(e as Map<String, Object?>))
        .toList();
  }

  /// `POST /experimental/workspace` — Create workspace
  Future<Workspace> experimentalWorkspaceCreate({
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/experimental/workspace',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST'),
    );
    return Workspace.fromJson(res.data! as Map<String, Object?>);
  }

  /// `POST /experimental/workspace/sync-list` — Sync workspace list
  Future<dynamic> experimentalWorkspaceSyncList({
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<Object?>(
      '/experimental/workspace/sync-list',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'POST'),
    );
    return res.data;
  }

  /// `GET /experimental/workspace/status` — Workspace status
  Future<List<WorkspaceEventConnectionStatus>> experimentalWorkspaceStatus({
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<List<dynamic>>(
      '/experimental/workspace/status',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'GET'),
    );
    return (res.data! as List)
        .map(
          (e) => WorkspaceEventConnectionStatus.fromJson(
            e as Map<String, Object?>,
          ),
        )
        .toList();
  }

  /// `DELETE /experimental/workspace/{id}` — Remove workspace
  Future<Workspace> experimentalWorkspaceRemove({
    required String id,
    String? directory,
    String? workspace,
  }) async {
    final res = await _dio.request<Object?>(
      '/experimental/workspace/{id}'.replaceAll(
        '{id}',
        Uri.encodeComponent(id.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      options: Options(method: 'DELETE'),
    );
    return Workspace.fromJson(res.data! as Map<String, Object?>);
  }

  /// `POST /experimental/workspace/warp` — Warp session into workspace
  Future<dynamic> experimentalWorkspaceWarp({
    String? directory,
    String? workspace,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/experimental/workspace/warp',
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
      },
      data: body,
      options: Options(method: 'POST'),
    );
    return res.data;
  }

  /// `GET /api/health` — Check server health
  Future<V2HealthGetResponse> v2HealthGet() async {
    final res = await _dio.request<Object?>(
      '/api/health',
      options: Options(method: 'GET'),
    );
    return V2HealthGetResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /api/location` — Get location
  Future<LocationInfo> v2LocationGet({String? location}) async {
    final res = await _dio.request<Object?>(
      '/api/location',
      queryParameters: {if (location != null) 'location': location},
      options: Options(method: 'GET'),
    );
    return LocationInfo.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /api/agent` — List agents
  Future<V2AgentListResponse> v2AgentList({String? location}) async {
    final res = await _dio.request<Object?>(
      '/api/agent',
      queryParameters: {if (location != null) 'location': location},
      options: Options(method: 'GET'),
    );
    return V2AgentListResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /api/session` — List sessions
  Future<SessionsResponse> v2SessionList({
    String? workspace,
    String? limit,
    String? order,
    String? search,
    String? directory,
    String? project,
    String? subpath,
    String? cursor,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/session',
      queryParameters: {
        if (workspace != null) 'workspace': workspace,
        if (limit != null) 'limit': limit,
        if (order != null) 'order': order,
        if (search != null) 'search': search,
        if (directory != null) 'directory': directory,
        if (project != null) 'project': project,
        if (subpath != null) 'subpath': subpath,
        if (cursor != null) 'cursor': cursor,
      },
      options: Options(method: 'GET'),
    );
    return SessionsResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `POST /api/session` — Create session
  Future<V2SessionCreateResponse> v2SessionCreate({
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/session',
      data: body,
      options: Options(method: 'POST'),
    );
    return V2SessionCreateResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /api/session/active` — List active sessions
  Future<V2SessionActiveResponse> v2SessionActive() async {
    final res = await _dio.request<Object?>(
      '/api/session/active',
      options: Options(method: 'GET'),
    );
    return V2SessionActiveResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /api/session/{sessionID}` — Get session
  Future<V2SessionGetResponse> v2SessionGet({required String sessionID}) async {
    final res = await _dio.request<Object?>(
      '/api/session/{sessionID}'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      options: Options(method: 'GET'),
    );
    return V2SessionGetResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `POST /api/session/{sessionID}/agent` — Switch session agent
  Future<dynamic> v2SessionSwitchAgent({
    required String sessionID,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/session/{sessionID}/agent'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      data: body,
      options: Options(method: 'POST'),
    );
    return res.data;
  }

  /// `POST /api/session/{sessionID}/model` — Switch session model
  Future<dynamic> v2SessionSwitchModel({
    required String sessionID,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/session/{sessionID}/model'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      data: body,
      options: Options(method: 'POST'),
    );
    return res.data;
  }

  /// `POST /api/session/{sessionID}/prompt` — Send message
  Future<V2SessionPromptResponse> v2SessionPrompt({
    required String sessionID,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/session/{sessionID}/prompt'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      data: body,
      options: Options(method: 'POST'),
    );
    return V2SessionPromptResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `POST /api/session/{sessionID}/compact` — Compact session
  Future<dynamic> v2SessionCompact({required String sessionID}) async {
    final res = await _dio.request<Object?>(
      '/api/session/{sessionID}/compact'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      options: Options(method: 'POST'),
    );
    return res.data;
  }

  /// `POST /api/session/{sessionID}/wait` — Wait for session
  Future<dynamic> v2SessionWait({required String sessionID}) async {
    final res = await _dio.request<Object?>(
      '/api/session/{sessionID}/wait'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      options: Options(method: 'POST'),
    );
    return res.data;
  }

  /// `POST /api/session/{sessionID}/revert/stage` — Stage session revert
  Future<V2SessionRevertStageResponse> v2SessionRevertStage({
    required String sessionID,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/session/{sessionID}/revert/stage'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      data: body,
      options: Options(method: 'POST'),
    );
    return V2SessionRevertStageResponse.fromJson(
      res.data! as Map<String, Object?>,
    );
  }

  /// `POST /api/session/{sessionID}/revert/clear` — Clear staged revert
  Future<dynamic> v2SessionRevertClear({required String sessionID}) async {
    final res = await _dio.request<Object?>(
      '/api/session/{sessionID}/revert/clear'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      options: Options(method: 'POST'),
    );
    return res.data;
  }

  /// `POST /api/session/{sessionID}/revert/commit` — Commit staged revert
  Future<dynamic> v2SessionRevertCommit({required String sessionID}) async {
    final res = await _dio.request<Object?>(
      '/api/session/{sessionID}/revert/commit'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      options: Options(method: 'POST'),
    );
    return res.data;
  }

  /// `GET /api/session/{sessionID}/context` — Get session context
  Future<V2SessionContextResponse> v2SessionContext({
    required String sessionID,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/session/{sessionID}/context'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      options: Options(method: 'GET'),
    );
    return V2SessionContextResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /api/session/{sessionID}/history` — Get session history
  Future<SessionHistory> v2SessionHistory({
    required String sessionID,
    String? limit,
    String? after,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/session/{sessionID}/history'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      queryParameters: {
        if (limit != null) 'limit': limit,
        if (after != null) 'after': after,
      },
      options: Options(method: 'GET'),
    );
    return SessionHistory.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /api/session/{sessionID}/event` — Subscribe to session events
  Future<Stream<List<int>>> v2SessionEvents({
    required String sessionID,
    String? after,
  }) async {
    final res = await _dio.get<ResponseBody>(
      '/api/session/{sessionID}/event'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      queryParameters: {if (after != null) 'after': after},
      options: Options(method: 'GET', responseType: ResponseType.stream),
    );
    return res.data!.stream;
  }

  /// `POST /api/session/{sessionID}/interrupt` — Interrupt session execution
  Future<dynamic> v2SessionInterrupt({required String sessionID}) async {
    final res = await _dio.request<Object?>(
      '/api/session/{sessionID}/interrupt'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      options: Options(method: 'POST'),
    );
    return res.data;
  }

  /// `GET /api/session/{sessionID}/message/{messageID}` — Get session message
  Future<V2SessionMessageResponse> v2SessionMessage({
    required String sessionID,
    required String messageID,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/session/{sessionID}/message/{messageID}'
          .replaceAll('{sessionID}', Uri.encodeComponent(sessionID.toString()))
          .replaceAll('{messageID}', Uri.encodeComponent(messageID.toString())),
      options: Options(method: 'GET'),
    );
    return V2SessionMessageResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /api/session/{sessionID}/message` — Get session messages
  Future<SessionMessagesResponse> v2SessionMessages({
    required String sessionID,
    String? limit,
    String? order,
    String? cursor,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/session/{sessionID}/message'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      queryParameters: {
        if (limit != null) 'limit': limit,
        if (order != null) 'order': order,
        if (cursor != null) 'cursor': cursor,
      },
      options: Options(method: 'GET'),
    );
    return SessionMessagesResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /api/model` — List models
  Future<V2ModelListResponse> v2ModelList({String? location}) async {
    final res = await _dio.request<Object?>(
      '/api/model',
      queryParameters: {if (location != null) 'location': location},
      options: Options(method: 'GET'),
    );
    return V2ModelListResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /api/provider` — List providers
  Future<V2ProviderListResponse> v2ProviderList({String? location}) async {
    final res = await _dio.request<Object?>(
      '/api/provider',
      queryParameters: {if (location != null) 'location': location},
      options: Options(method: 'GET'),
    );
    return V2ProviderListResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /api/provider/{providerID}` — Get provider
  Future<V2ProviderGetResponse> v2ProviderGet({
    required String providerID,
    String? location,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/provider/{providerID}'.replaceAll(
        '{providerID}',
        Uri.encodeComponent(providerID.toString()),
      ),
      queryParameters: {if (location != null) 'location': location},
      options: Options(method: 'GET'),
    );
    return V2ProviderGetResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /api/integration` — List integrations
  Future<V2IntegrationListResponse> v2IntegrationList({
    String? location,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/integration',
      queryParameters: {if (location != null) 'location': location},
      options: Options(method: 'GET'),
    );
    return V2IntegrationListResponse.fromJson(
      res.data! as Map<String, Object?>,
    );
  }

  /// `GET /api/integration/{integrationID}` — Get integration
  Future<V2IntegrationGetResponse> v2IntegrationGet({
    required String integrationID,
    String? location,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/integration/{integrationID}'.replaceAll(
        '{integrationID}',
        Uri.encodeComponent(integrationID.toString()),
      ),
      queryParameters: {if (location != null) 'location': location},
      options: Options(method: 'GET'),
    );
    return V2IntegrationGetResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `POST /api/integration/{integrationID}/connect/key` — Connect with key
  Future<dynamic> v2IntegrationConnectKey({
    required String integrationID,
    String? location,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/integration/{integrationID}/connect/key'.replaceAll(
        '{integrationID}',
        Uri.encodeComponent(integrationID.toString()),
      ),
      queryParameters: {if (location != null) 'location': location},
      data: body,
      options: Options(method: 'POST'),
    );
    return res.data;
  }

  /// `POST /api/integration/{integrationID}/connect/oauth` — Begin OAuth connection
  Future<V2IntegrationConnectOauthResponse> v2IntegrationConnectOauth({
    required String integrationID,
    String? location,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/integration/{integrationID}/connect/oauth'.replaceAll(
        '{integrationID}',
        Uri.encodeComponent(integrationID.toString()),
      ),
      queryParameters: {if (location != null) 'location': location},
      data: body,
      options: Options(method: 'POST'),
    );
    return V2IntegrationConnectOauthResponse.fromJson(
      res.data! as Map<String, Object?>,
    );
  }

  /// `GET /api/integration/attempt/{attemptID}` — Get OAuth attempt status
  Future<V2IntegrationAttemptStatusResponse> v2IntegrationAttemptStatus({
    required String attemptID,
    String? location,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/integration/attempt/{attemptID}'.replaceAll(
        '{attemptID}',
        Uri.encodeComponent(attemptID.toString()),
      ),
      queryParameters: {if (location != null) 'location': location},
      options: Options(method: 'GET'),
    );
    return V2IntegrationAttemptStatusResponse.fromJson(
      res.data! as Map<String, Object?>,
    );
  }

  /// `DELETE /api/integration/attempt/{attemptID}` — Cancel OAuth connection
  Future<dynamic> v2IntegrationAttemptCancel({
    required String attemptID,
    String? location,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/integration/attempt/{attemptID}'.replaceAll(
        '{attemptID}',
        Uri.encodeComponent(attemptID.toString()),
      ),
      queryParameters: {if (location != null) 'location': location},
      options: Options(method: 'DELETE'),
    );
    return res.data;
  }

  /// `POST /api/integration/attempt/{attemptID}/complete` — Complete OAuth connection
  Future<dynamic> v2IntegrationAttemptComplete({
    required String attemptID,
    String? location,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/integration/attempt/{attemptID}/complete'.replaceAll(
        '{attemptID}',
        Uri.encodeComponent(attemptID.toString()),
      ),
      queryParameters: {if (location != null) 'location': location},
      data: body,
      options: Options(method: 'POST'),
    );
    return res.data;
  }

  /// `PATCH /api/credential/{credentialID}` — Update credential
  Future<dynamic> v2CredentialUpdate({
    required String credentialID,
    String? location,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/credential/{credentialID}'.replaceAll(
        '{credentialID}',
        Uri.encodeComponent(credentialID.toString()),
      ),
      queryParameters: {if (location != null) 'location': location},
      data: body,
      options: Options(method: 'PATCH'),
    );
    return res.data;
  }

  /// `DELETE /api/credential/{credentialID}` — Remove credential
  Future<dynamic> v2CredentialRemove({
    required String credentialID,
    String? location,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/credential/{credentialID}'.replaceAll(
        '{credentialID}',
        Uri.encodeComponent(credentialID.toString()),
      ),
      queryParameters: {if (location != null) 'location': location},
      options: Options(method: 'DELETE'),
    );
    return res.data;
  }

  /// `GET /api/permission/request` — List pending permission requests
  Future<V2PermissionRequestListResponse> v2PermissionRequestList({
    String? location,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/permission/request',
      queryParameters: {if (location != null) 'location': location},
      options: Options(method: 'GET'),
    );
    return V2PermissionRequestListResponse.fromJson(
      res.data! as Map<String, Object?>,
    );
  }

  /// `GET /api/permission/saved` — List saved permissions
  Future<V2PermissionSavedListResponse> v2PermissionSavedList({
    String? projectID,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/permission/saved',
      queryParameters: {if (projectID != null) 'projectID': projectID},
      options: Options(method: 'GET'),
    );
    return V2PermissionSavedListResponse.fromJson(
      res.data! as Map<String, Object?>,
    );
  }

  /// `DELETE /api/permission/saved/{id}` — Remove saved permission
  Future<dynamic> v2PermissionSavedRemove({required String id}) async {
    final res = await _dio.request<Object?>(
      '/api/permission/saved/{id}'.replaceAll(
        '{id}',
        Uri.encodeComponent(id.toString()),
      ),
      options: Options(method: 'DELETE'),
    );
    return res.data;
  }

  /// `POST /api/session/{sessionID}/permission` — Create permission request
  Future<V2SessionPermissionCreateResponse> v2SessionPermissionCreate({
    required String sessionID,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/session/{sessionID}/permission'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      data: body,
      options: Options(method: 'POST'),
    );
    return V2SessionPermissionCreateResponse.fromJson(
      res.data! as Map<String, Object?>,
    );
  }

  /// `GET /api/session/{sessionID}/permission` — List session permission requests
  Future<V2SessionPermissionListResponse> v2SessionPermissionList({
    required String sessionID,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/session/{sessionID}/permission'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      options: Options(method: 'GET'),
    );
    return V2SessionPermissionListResponse.fromJson(
      res.data! as Map<String, Object?>,
    );
  }

  /// `GET /api/session/{sessionID}/permission/{requestID}` — Get permission request
  Future<V2SessionPermissionGetResponse> v2SessionPermissionGet({
    required String sessionID,
    required String requestID,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/session/{sessionID}/permission/{requestID}'
          .replaceAll('{sessionID}', Uri.encodeComponent(sessionID.toString()))
          .replaceAll('{requestID}', Uri.encodeComponent(requestID.toString())),
      options: Options(method: 'GET'),
    );
    return V2SessionPermissionGetResponse.fromJson(
      res.data! as Map<String, Object?>,
    );
  }

  /// `POST /api/session/{sessionID}/permission/{requestID}/reply` — Reply to pending permission request
  Future<dynamic> v2SessionPermissionReply({
    required String sessionID,
    required String requestID,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/session/{sessionID}/permission/{requestID}/reply'
          .replaceAll('{sessionID}', Uri.encodeComponent(sessionID.toString()))
          .replaceAll('{requestID}', Uri.encodeComponent(requestID.toString())),
      data: body,
      options: Options(method: 'POST'),
    );
    return res.data;
  }

  /// `GET /api/fs/read/*` — Read file
  Future<List<int>> v2FsRead({String? location}) async {
    final res = await _dio.request<List<int>>(
      '/api/fs/read/*',
      queryParameters: {if (location != null) 'location': location},
      options: Options(method: 'GET', responseType: ResponseType.bytes),
    );
    return res.data!;
  }

  /// `GET /api/fs/list` — List directory
  Future<V2FsListResponse> v2FsList({String? location, String? path}) async {
    final res = await _dio.request<Object?>(
      '/api/fs/list',
      queryParameters: {
        if (location != null) 'location': location,
        if (path != null) 'path': path,
      },
      options: Options(method: 'GET'),
    );
    return V2FsListResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /api/fs/find` — Find files
  Future<V2FsFindResponse> v2FsFind({
    String? location,
    required String query,
    String? type,
    String? limit,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/fs/find',
      queryParameters: {
        if (location != null) 'location': location,
        if (query != null) 'query': query,
        if (type != null) 'type': type,
        if (limit != null) 'limit': limit,
      },
      options: Options(method: 'GET'),
    );
    return V2FsFindResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /api/command` — List commands
  Future<V2CommandListResponse> v2CommandList({String? location}) async {
    final res = await _dio.request<Object?>(
      '/api/command',
      queryParameters: {if (location != null) 'location': location},
      options: Options(method: 'GET'),
    );
    return V2CommandListResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /api/skill` — List skills
  Future<V2SkillListResponse> v2SkillList({String? location}) async {
    final res = await _dio.request<Object?>(
      '/api/skill',
      queryParameters: {if (location != null) 'location': location},
      options: Options(method: 'GET'),
    );
    return V2SkillListResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /api/event` — Subscribe to events
  Future<Stream<List<int>>> v2EventSubscribe() async {
    final res = await _dio.get<ResponseBody>(
      '/api/event',
      options: Options(method: 'GET', responseType: ResponseType.stream),
    );
    return res.data!.stream;
  }

  /// `GET /api/pty` — List PTY sessions
  Future<V2PtyListResponse> v2PtyList({String? location}) async {
    final res = await _dio.request<Object?>(
      '/api/pty',
      queryParameters: {if (location != null) 'location': location},
      options: Options(method: 'GET'),
    );
    return V2PtyListResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `POST /api/pty` — Create PTY session
  Future<V2PtyCreateResponse> v2PtyCreate({
    String? location,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/pty',
      queryParameters: {if (location != null) 'location': location},
      data: body,
      options: Options(method: 'POST'),
    );
    return V2PtyCreateResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `GET /api/pty/{ptyID}` — Get PTY session
  Future<V2PtyGetResponse> v2PtyGet({
    required String ptyID,
    String? location,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/pty/{ptyID}'.replaceAll(
        '{ptyID}',
        Uri.encodeComponent(ptyID.toString()),
      ),
      queryParameters: {if (location != null) 'location': location},
      options: Options(method: 'GET'),
    );
    return V2PtyGetResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `PUT /api/pty/{ptyID}` — Update PTY session
  Future<V2PtyUpdateResponse> v2PtyUpdate({
    required String ptyID,
    String? location,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/pty/{ptyID}'.replaceAll(
        '{ptyID}',
        Uri.encodeComponent(ptyID.toString()),
      ),
      queryParameters: {if (location != null) 'location': location},
      data: body,
      options: Options(method: 'PUT'),
    );
    return V2PtyUpdateResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `DELETE /api/pty/{ptyID}` — Remove PTY session
  Future<dynamic> v2PtyRemove({required String ptyID, String? location}) async {
    final res = await _dio.request<Object?>(
      '/api/pty/{ptyID}'.replaceAll(
        '{ptyID}',
        Uri.encodeComponent(ptyID.toString()),
      ),
      queryParameters: {if (location != null) 'location': location},
      options: Options(method: 'DELETE'),
    );
    return res.data;
  }

  /// `POST /api/pty/{ptyID}/connect-token` — Create PTY WebSocket token
  Future<V2PtyConnectTokenResponse> v2PtyConnectToken({
    required String ptyID,
    String? location,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/pty/{ptyID}/connect-token'.replaceAll(
        '{ptyID}',
        Uri.encodeComponent(ptyID.toString()),
      ),
      queryParameters: {if (location != null) 'location': location},
      options: Options(method: 'POST'),
    );
    return V2PtyConnectTokenResponse.fromJson(
      res.data! as Map<String, Object?>,
    );
  }

  /// `GET /api/pty/{ptyID}/connect` — Connect to PTY session
  Future<bool> v2PtyConnect({
    required String ptyID,
    String? locationDirectory,
    String? locationWorkspace,
    String? cursor,
    String? ticket,
  }) async {
    final res = await _dio.request<String>(
      '/api/pty/{ptyID}/connect'.replaceAll(
        '{ptyID}',
        Uri.encodeComponent(ptyID.toString()),
      ),
      queryParameters: {
        if (locationDirectory != null) 'location[directory]': locationDirectory,
        if (locationWorkspace != null) 'location[workspace]': locationWorkspace,
        if (cursor != null) 'cursor': cursor,
        if (ticket != null) 'ticket': ticket,
      },
      options: Options(method: 'GET', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }

  /// `GET /api/question/request` — List pending question requests
  Future<V2QuestionRequestListResponse> v2QuestionRequestList({
    String? location,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/question/request',
      queryParameters: {if (location != null) 'location': location},
      options: Options(method: 'GET'),
    );
    return V2QuestionRequestListResponse.fromJson(
      res.data! as Map<String, Object?>,
    );
  }

  /// `GET /api/session/{sessionID}/question` — List session question requests
  Future<V2SessionQuestionListResponse> v2SessionQuestionList({
    required String sessionID,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/session/{sessionID}/question'.replaceAll(
        '{sessionID}',
        Uri.encodeComponent(sessionID.toString()),
      ),
      options: Options(method: 'GET'),
    );
    return V2SessionQuestionListResponse.fromJson(
      res.data! as Map<String, Object?>,
    );
  }

  /// `POST /api/session/{sessionID}/question/{requestID}/reply` — Reply to pending question request
  Future<dynamic> v2SessionQuestionReply({
    required String sessionID,
    required String requestID,
    QuestionV2Reply? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/session/{sessionID}/question/{requestID}/reply'
          .replaceAll('{sessionID}', Uri.encodeComponent(sessionID.toString()))
          .replaceAll('{requestID}', Uri.encodeComponent(requestID.toString())),
      data: body?.toJson(),
      options: Options(method: 'POST'),
    );
    return res.data;
  }

  /// `POST /api/session/{sessionID}/question/{requestID}/reject` — Reject pending question request
  Future<dynamic> v2SessionQuestionReject({
    required String sessionID,
    required String requestID,
  }) async {
    final res = await _dio.request<Object?>(
      '/api/session/{sessionID}/question/{requestID}/reject'
          .replaceAll('{sessionID}', Uri.encodeComponent(sessionID.toString()))
          .replaceAll('{requestID}', Uri.encodeComponent(requestID.toString())),
      options: Options(method: 'POST'),
    );
    return res.data;
  }

  /// `GET /api/reference` — List references
  Future<V2ReferenceListResponse> v2ReferenceList({String? location}) async {
    final res = await _dio.request<Object?>(
      '/api/reference',
      queryParameters: {if (location != null) 'location': location},
      options: Options(method: 'GET'),
    );
    return V2ReferenceListResponse.fromJson(res.data! as Map<String, Object?>);
  }

  /// `POST /experimental/project/{projectID}/copy` — v2.projectCopy.create
  Future<ProjectCopyCopy> v2ProjectCopyCreate({
    required String projectID,
    String? location,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/experimental/project/{projectID}/copy'.replaceAll(
        '{projectID}',
        Uri.encodeComponent(projectID.toString()),
      ),
      queryParameters: {if (location != null) 'location': location},
      data: body,
      options: Options(method: 'POST'),
    );
    return ProjectCopyCopy.fromJson(res.data! as Map<String, Object?>);
  }

  /// `DELETE /experimental/project/{projectID}/copy` — v2.projectCopy.remove
  Future<dynamic> v2ProjectCopyRemove({
    required String projectID,
    String? location,
    Map<String, Object?>? body,
  }) async {
    final res = await _dio.request<Object?>(
      '/experimental/project/{projectID}/copy'.replaceAll(
        '{projectID}',
        Uri.encodeComponent(projectID.toString()),
      ),
      queryParameters: {if (location != null) 'location': location},
      data: body,
      options: Options(method: 'DELETE'),
    );
    return res.data;
  }

  /// `POST /experimental/project/{projectID}/copy/refresh` — v2.projectCopy.refresh
  Future<dynamic> v2ProjectCopyRefresh({
    required String projectID,
    String? location,
  }) async {
    final res = await _dio.request<Object?>(
      '/experimental/project/{projectID}/copy/refresh'.replaceAll(
        '{projectID}',
        Uri.encodeComponent(projectID.toString()),
      ),
      queryParameters: {if (location != null) 'location': location},
      options: Options(method: 'POST'),
    );
    return res.data;
  }

  /// `GET /pty/{ptyID}/connect` — Connect to PTY session
  Future<bool> ptyConnect({
    required String ptyID,
    String? directory,
    String? workspace,
    String? cursor,
    String? ticket,
  }) async {
    final res = await _dio.request<String>(
      '/pty/{ptyID}/connect'.replaceAll(
        '{ptyID}',
        Uri.encodeComponent(ptyID.toString()),
      ),
      queryParameters: {
        if (directory != null) 'directory': directory,
        if (workspace != null) 'workspace': workspace,
        if (cursor != null) 'cursor': cursor,
        if (ticket != null) 'ticket': ticket,
      },
      options: Options(method: 'GET', responseType: ResponseType.plain),
    );
    return (res.data! as String).toLowerCase() == 'true';
  }
}
