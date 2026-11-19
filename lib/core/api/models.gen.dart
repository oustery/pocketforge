// GENERATED - DO NOT EDIT BY HAND
// Сгенерировано scripts/gen_api_client.py из спецификации opencode.

/// Заглушка для неизвестных вариантов union.
class UnknownEvent {
  /// Создаёт обёртку над сырым JSON.
  UnknownEvent(this.raw);

  /// Сырой JSON события.
  final Map<String, Object?> raw;
}

class Event {
  /// Диспетчеризация anyOf-вариантов по полю 'type'.
  static dynamic fromJson(Map<String, Object?> json) {
    final t = json['type'] as String?;
    switch (t) {
      case 'catalog.updated':
        return EventCatalogUpdated.fromJson(json);
      case 'command.executed':
        return EventCommandExecuted.fromJson(json);
      case 'file.edited':
        return EventFileEdited.fromJson(json);
      case 'file.watcher.updated':
        return EventFileWatcherUpdated.fromJson(json);
      case 'global.disposed':
        return EventGlobalDisposed.fromJson(json);
      case 'installation.update-available':
        return EventInstallationUpdateAvailable.fromJson(json);
      case 'installation.updated':
        return EventInstallationUpdated.fromJson(json);
      case 'integration.connection.updated':
        return EventIntegrationConnectionUpdated.fromJson(json);
      case 'integration.updated':
        return EventIntegrationUpdated.fromJson(json);
      case 'lsp.updated':
        return EventLspUpdated.fromJson(json);
      case 'mcp.browser.open.failed':
        return EventMcpBrowserOpenFailed.fromJson(json);
      case 'mcp.tools.changed':
        return EventMcpToolsChanged.fromJson(json);
      case 'message.part.delta':
        return EventMessagePartDelta.fromJson(json);
      case 'message.part.removed':
        return EventMessagePartRemoved.fromJson(json);
      case 'message.part.updated':
        return EventMessagePartUpdated.fromJson(json);
      case 'message.removed':
        return EventMessageRemoved.fromJson(json);
      case 'message.updated':
        return EventMessageUpdated.fromJson(json);
      case 'models-dev.refreshed':
        return EventModelsDevRefreshed.fromJson(json);
      case 'permission.asked':
        return EventPermissionAsked.fromJson(json);
      case 'permission.replied':
        return EventPermissionReplied.fromJson(json);
      case 'permission.v2.asked':
        return EventPermissionV2Asked.fromJson(json);
      case 'permission.v2.replied':
        return EventPermissionV2Replied.fromJson(json);
      case 'plugin.added':
        return EventPluginAdded.fromJson(json);
      case 'project.directories.updated':
        return EventProjectDirectoriesUpdated.fromJson(json);
      case 'project.updated':
        return EventProjectUpdated.fromJson(json);
      case 'pty.created':
        return EventPtyCreated.fromJson(json);
      case 'pty.deleted':
        return EventPtyDeleted.fromJson(json);
      case 'pty.exited':
        return EventPtyExited.fromJson(json);
      case 'pty.updated':
        return EventPtyUpdated.fromJson(json);
      case 'question.asked':
        return EventQuestionAsked.fromJson(json);
      case 'question.rejected':
        return EventQuestionRejected.fromJson(json);
      case 'question.replied':
        return EventQuestionReplied.fromJson(json);
      case 'question.v2.asked':
        return EventQuestionV2Asked.fromJson(json);
      case 'question.v2.rejected':
        return EventQuestionV2Rejected.fromJson(json);
      case 'question.v2.replied':
        return EventQuestionV2Replied.fromJson(json);
      case 'reference.updated':
        return EventReferenceUpdated.fromJson(json);
      case 'server.connected':
        return EventServerConnected.fromJson(json);
      case 'server.instance.disposed':
        return EventServerInstanceDisposed.fromJson(json);
      case 'session.compacted':
        return EventSessionCompacted.fromJson(json);
      case 'session.created':
        return EventSessionCreated.fromJson(json);
      case 'session.deleted':
        return EventSessionDeleted.fromJson(json);
      case 'session.diff':
        return EventSessionDiff.fromJson(json);
      case 'session.error':
        return EventSessionError.fromJson(json);
      case 'session.idle':
        return EventSessionIdle.fromJson(json);
      case 'session.next.agent.switched':
        return EventSessionNextAgentSwitched.fromJson(json);
      case 'session.next.compaction.delta':
        return EventSessionNextCompactionDelta.fromJson(json);
      case 'session.next.compaction.ended':
        return EventSessionNextCompactionEnded.fromJson(json);
      case 'session.next.compaction.started':
        return EventSessionNextCompactionStarted.fromJson(json);
      case 'session.next.context.updated':
        return EventSessionNextContextUpdated.fromJson(json);
      case 'session.next.model.switched':
        return EventSessionNextModelSwitched.fromJson(json);
      case 'session.next.moved':
        return EventSessionNextMoved.fromJson(json);
      case 'session.next.prompt.admitted':
        return EventSessionNextPromptAdmitted.fromJson(json);
      case 'session.next.prompted':
        return EventSessionNextPrompted.fromJson(json);
      case 'session.next.reasoning.delta':
        return EventSessionNextReasoningDelta.fromJson(json);
      case 'session.next.reasoning.ended':
        return EventSessionNextReasoningEnded.fromJson(json);
      case 'session.next.reasoning.started':
        return EventSessionNextReasoningStarted.fromJson(json);
      case 'session.next.retried':
        return EventSessionNextRetried.fromJson(json);
      case 'session.next.revert.cleared':
        return EventSessionNextRevertCleared.fromJson(json);
      case 'session.next.revert.committed':
        return EventSessionNextRevertCommitted.fromJson(json);
      case 'session.next.revert.staged':
        return EventSessionNextRevertStaged.fromJson(json);
      case 'session.next.shell.ended':
        return EventSessionNextShellEnded.fromJson(json);
      case 'session.next.shell.started':
        return EventSessionNextShellStarted.fromJson(json);
      case 'session.next.step.ended':
        return EventSessionNextStepEnded.fromJson(json);
      case 'session.next.step.failed':
        return EventSessionNextStepFailed.fromJson(json);
      case 'session.next.step.started':
        return EventSessionNextStepStarted.fromJson(json);
      case 'session.next.synthetic':
        return EventSessionNextSynthetic.fromJson(json);
      case 'session.next.text.delta':
        return EventSessionNextTextDelta.fromJson(json);
      case 'session.next.text.ended':
        return EventSessionNextTextEnded.fromJson(json);
      case 'session.next.text.started':
        return EventSessionNextTextStarted.fromJson(json);
      case 'session.next.tool.called':
        return EventSessionNextToolCalled.fromJson(json);
      case 'session.next.tool.failed':
        return EventSessionNextToolFailed.fromJson(json);
      case 'session.next.tool.input.delta':
        return EventSessionNextToolInputDelta.fromJson(json);
      case 'session.next.tool.input.ended':
        return EventSessionNextToolInputEnded.fromJson(json);
      case 'session.next.tool.input.started':
        return EventSessionNextToolInputStarted.fromJson(json);
      case 'session.next.tool.progress':
        return EventSessionNextToolProgress.fromJson(json);
      case 'session.next.tool.success':
        return EventSessionNextToolSuccess.fromJson(json);
      case 'session.status':
        return EventSessionStatus.fromJson(json);
      case 'session.updated':
        return EventSessionUpdated.fromJson(json);
      case 'todo.updated':
        return EventTodoUpdated.fromJson(json);
      case 'tui.command.execute':
        return EventTuiCommandExecute.fromJson(json);
      case 'tui.prompt.append':
        return EventTuiPromptAppend.fromJson(json);
      case 'tui.session.select':
        return EventTuiSessionSelect.fromJson(json);
      case 'tui.toast.show':
        return EventTuiToastShow.fromJson(json);
      case 'vcs.branch.updated':
        return EventVcsBranchUpdated.fromJson(json);
      case 'workspace.failed':
        return EventWorkspaceFailed.fromJson(json);
      case 'workspace.ready':
        return EventWorkspaceReady.fromJson(json);
      case 'workspace.status':
        return EventWorkspaceStatus.fromJson(json);
      case 'worktree.failed':
        return EventWorktreeFailed.fromJson(json);
      case 'worktree.ready':
        return EventWorktreeReady.fromJson(json);
      default:
        return UnknownEvent(json);
    }
  }
}

class Auth {
  /// Диспетчеризация anyOf-вариантов по полю 'type'.
  static dynamic fromJson(Map<String, Object?> json) {
    final t = json['type'] as String?;
    switch (t) {
      case 'api':
        return ApiAuth.fromJson(json);
      case 'oauth':
        return OAuth.fromJson(json);
      case 'wellknown':
        return WellKnownAuth.fromJson(json);
      default:
        return UnknownEvent(json);
    }
  }
}

class OutputFormat {
  /// Диспетчеризация anyOf-вариантов по полю 'type'.
  static dynamic fromJson(Map<String, Object?> json) {
    final t = json['type'] as String?;
    switch (t) {
      case 'json_schema':
        return OutputFormatJsonSchema.fromJson(json);
      case 'text':
        return OutputFormatText.fromJson(json);
      default:
        return UnknownEvent(json);
    }
  }
}

class Message {
  /// Диспетчеризация anyOf-вариантов по полю 'role'.
  static dynamic fromJson(Map<String, Object?> json) {
    final t = json['role'] as String?;
    switch (t) {
      case 'assistant':
        return AssistantMessage.fromJson(json);
      case 'user':
        return UserMessage.fromJson(json);
      default:
        return UnknownEvent(json);
    }
  }
}

class FilePartSource {
  /// Диспетчеризация anyOf-вариантов по полю 'type'.
  static dynamic fromJson(Map<String, Object?> json) {
    final t = json['type'] as String?;
    switch (t) {
      case 'file':
        return FileSource.fromJson(json);
      case 'resource':
        return ResourceSource.fromJson(json);
      case 'symbol':
        return SymbolSource.fromJson(json);
      default:
        return UnknownEvent(json);
    }
  }
}

class ToolState {
  /// Диспетчеризация anyOf-вариантов по полю 'status'.
  static dynamic fromJson(Map<String, Object?> json) {
    final t = json['status'] as String?;
    switch (t) {
      case 'completed':
        return ToolStateCompleted.fromJson(json);
      case 'error':
        return ToolStateError.fromJson(json);
      case 'pending':
        return ToolStatePending.fromJson(json);
      case 'running':
        return ToolStateRunning.fromJson(json);
      default:
        return UnknownEvent(json);
    }
  }
}

class Part {
  /// Диспетчеризация anyOf-вариантов по полю 'type'.
  static dynamic fromJson(Map<String, Object?> json) {
    final t = json['type'] as String?;
    switch (t) {
      case 'agent':
        return AgentPart.fromJson(json);
      case 'compaction':
        return CompactionPart.fromJson(json);
      case 'file':
        return FilePart.fromJson(json);
      case 'patch':
        return PatchPart.fromJson(json);
      case 'reasoning':
        return ReasoningPart.fromJson(json);
      case 'retry':
        return RetryPart.fromJson(json);
      case 'snapshot':
        return SnapshotPart.fromJson(json);
      case 'step-finish':
        return StepFinishPart.fromJson(json);
      case 'step-start':
        return StepStartPart.fromJson(json);
      case 'subtask':
        return SubtaskPart.fromJson(json);
      case 'text':
        return TextPart.fromJson(json);
      case 'tool':
        return ToolPart.fromJson(json);
      default:
        return UnknownEvent(json);
    }
  }
}

class MCPStatus {
  /// Диспетчеризация anyOf-вариантов по полю 'status'.
  static dynamic fromJson(Map<String, Object?> json) {
    final t = json['status'] as String?;
    switch (t) {
      case 'connected':
        return MCPStatusConnected.fromJson(json);
      case 'disabled':
        return MCPStatusDisabled.fromJson(json);
      case 'failed':
        return MCPStatusFailed.fromJson(json);
      case 'needs_auth':
        return MCPStatusNeedsAuth.fromJson(json);
      case 'needs_client_registration':
        return MCPStatusNeedsClientRegistration.fromJson(json);
      default:
        return UnknownEvent(json);
    }
  }
}

class SessionDurableEvent {
  /// Диспетчеризация anyOf-вариантов по полю 'type'.
  static dynamic fromJson(Map<String, Object?> json) {
    final t = json['type'] as String?;
    switch (t) {
      case 'session.next.agent.switched':
        return SessionNextAgentSwitched.fromJson(json);
      case 'session.next.compaction.ended':
        return SessionNextCompactionEnded.fromJson(json);
      case 'session.next.compaction.started':
        return SessionNextCompactionStarted.fromJson(json);
      case 'session.next.context.updated':
        return SessionNextContextUpdated.fromJson(json);
      case 'session.next.model.switched':
        return SessionNextModelSwitched.fromJson(json);
      case 'session.next.moved':
        return SessionNextMoved.fromJson(json);
      case 'session.next.prompt.admitted':
        return SessionNextPromptAdmitted.fromJson(json);
      case 'session.next.prompted':
        return SessionNextPrompted.fromJson(json);
      case 'session.next.reasoning.ended':
        return SessionNextReasoningEnded.fromJson(json);
      case 'session.next.reasoning.started':
        return SessionNextReasoningStarted.fromJson(json);
      case 'session.next.retried':
        return SessionNextRetried.fromJson(json);
      case 'session.next.revert.cleared':
        return SessionNextRevertCleared.fromJson(json);
      case 'session.next.revert.committed':
        return SessionNextRevertCommitted.fromJson(json);
      case 'session.next.revert.staged':
        return SessionNextRevertStaged.fromJson(json);
      case 'session.next.shell.ended':
        return SessionNextShellEnded.fromJson(json);
      case 'session.next.shell.started':
        return SessionNextShellStarted.fromJson(json);
      case 'session.next.step.ended':
        return SessionNextStepEnded.fromJson(json);
      case 'session.next.step.failed':
        return SessionNextStepFailed.fromJson(json);
      case 'session.next.step.started':
        return SessionNextStepStarted.fromJson(json);
      case 'session.next.synthetic':
        return SessionNextSynthetic.fromJson(json);
      case 'session.next.text.ended':
        return SessionNextTextEnded.fromJson(json);
      case 'session.next.text.started':
        return SessionNextTextStarted.fromJson(json);
      case 'session.next.tool.called':
        return SessionNextToolCalled.fromJson(json);
      case 'session.next.tool.failed':
        return SessionNextToolFailed.fromJson(json);
      case 'session.next.tool.input.ended':
        return SessionNextToolInputEnded.fromJson(json);
      case 'session.next.tool.input.started':
        return SessionNextToolInputStarted.fromJson(json);
      case 'session.next.tool.progress':
        return SessionNextToolProgress.fromJson(json);
      case 'session.next.tool.success':
        return SessionNextToolSuccess.fromJson(json);
      default:
        return UnknownEvent(json);
    }
  }
}

class SessionMessage {
  /// Диспетчеризация anyOf-вариантов по полю 'type'.
  static dynamic fromJson(Map<String, Object?> json) {
    final t = json['type'] as String?;
    switch (t) {
      case 'agent-switched':
        return SessionMessageAgentSwitched.fromJson(json);
      case 'assistant':
        return SessionMessageAssistant.fromJson(json);
      case 'compaction':
        return SessionMessageCompaction.fromJson(json);
      case 'model-switched':
        return SessionMessageModelSwitched.fromJson(json);
      case 'shell':
        return SessionMessageShell.fromJson(json);
      case 'synthetic':
        return SessionMessageSynthetic.fromJson(json);
      case 'system':
        return SessionMessageSystem.fromJson(json);
      case 'user':
        return SessionMessageUser.fromJson(json);
      default:
        return UnknownEvent(json);
    }
  }
}

class V2Event {
  /// Диспетчеризация anyOf-вариантов по полю 'type'.
  static dynamic fromJson(Map<String, Object?> json) {
    final t = json['type'] as String?;
    switch (t) {
      case 'catalog.updated':
        return CatalogUpdated.fromJson(json);
      case 'command.executed':
        return CommandExecuted.fromJson(json);
      case 'file.edited':
        return FileEdited.fromJson(json);
      case 'file.watcher.updated':
        return FileWatcherUpdated.fromJson(json);
      case 'global.disposed':
        return GlobalDisposed.fromJson(json);
      case 'installation.update-available':
        return InstallationUpdateAvailable.fromJson(json);
      case 'installation.updated':
        return InstallationUpdated.fromJson(json);
      case 'integration.connection.updated':
        return IntegrationConnectionUpdated.fromJson(json);
      case 'integration.updated':
        return IntegrationUpdated.fromJson(json);
      case 'lsp.updated':
        return LspUpdated.fromJson(json);
      case 'mcp.browser.open.failed':
        return McpBrowserOpenFailed.fromJson(json);
      case 'mcp.tools.changed':
        return McpToolsChanged.fromJson(json);
      case 'message.part.delta':
        return MessagePartDelta.fromJson(json);
      case 'message.part.removed':
        return MessagePartRemoved.fromJson(json);
      case 'message.part.updated':
        return MessagePartUpdated.fromJson(json);
      case 'message.removed':
        return MessageRemoved.fromJson(json);
      case 'message.updated':
        return MessageUpdated.fromJson(json);
      case 'models-dev.refreshed':
        return ModelsDevRefreshed.fromJson(json);
      case 'permission.asked':
        return PermissionAsked.fromJson(json);
      case 'permission.replied':
        return PermissionReplied.fromJson(json);
      case 'permission.v2.asked':
        return PermissionV2Asked.fromJson(json);
      case 'permission.v2.replied':
        return PermissionV2Replied.fromJson(json);
      case 'plugin.added':
        return PluginAdded.fromJson(json);
      case 'project.directories.updated':
        return ProjectDirectoriesUpdated.fromJson(json);
      case 'project.updated':
        return ProjectUpdated.fromJson(json);
      case 'pty.created':
        return PtyCreated.fromJson(json);
      case 'pty.deleted':
        return PtyDeleted.fromJson(json);
      case 'pty.exited':
        return PtyExited.fromJson(json);
      case 'pty.updated':
        return PtyUpdated.fromJson(json);
      case 'question.asked':
        return QuestionAsked.fromJson(json);
      case 'question.rejected':
        return QuestionRejected.fromJson(json);
      case 'question.replied':
        return QuestionReplied.fromJson(json);
      case 'question.v2.asked':
        return QuestionV2Asked.fromJson(json);
      case 'question.v2.rejected':
        return QuestionV2Rejected.fromJson(json);
      case 'question.v2.replied':
        return QuestionV2Replied.fromJson(json);
      case 'reference.updated':
        return ReferenceUpdated.fromJson(json);
      case 'server.connected':
        return ServerConnected.fromJson(json);
      case 'session.compacted':
        return SessionCompacted.fromJson(json);
      case 'session.created':
        return SessionCreated.fromJson(json);
      case 'session.deleted':
        return SessionDeleted.fromJson(json);
      case 'session.diff':
        return SessionDiff.fromJson(json);
      case 'session.error':
        return SessionError.fromJson(json);
      case 'session.idle':
        return SessionIdle.fromJson(json);
      case 'session.next.agent.switched':
        return SessionNextAgentSwitched.fromJson(json);
      case 'session.next.compaction.delta':
        return SessionNextCompactionDelta.fromJson(json);
      case 'session.next.compaction.ended':
        return SessionNextCompactionEnded.fromJson(json);
      case 'session.next.compaction.started':
        return SessionNextCompactionStarted.fromJson(json);
      case 'session.next.context.updated':
        return SessionNextContextUpdated.fromJson(json);
      case 'session.next.model.switched':
        return SessionNextModelSwitched.fromJson(json);
      case 'session.next.moved':
        return SessionNextMoved.fromJson(json);
      case 'session.next.prompt.admitted':
        return SessionNextPromptAdmitted.fromJson(json);
      case 'session.next.prompted':
        return SessionNextPrompted.fromJson(json);
      case 'session.next.reasoning.delta':
        return SessionNextReasoningDelta.fromJson(json);
      case 'session.next.reasoning.ended':
        return SessionNextReasoningEnded.fromJson(json);
      case 'session.next.reasoning.started':
        return SessionNextReasoningStarted.fromJson(json);
      case 'session.next.retried':
        return SessionNextRetried.fromJson(json);
      case 'session.next.revert.cleared':
        return SessionNextRevertCleared.fromJson(json);
      case 'session.next.revert.committed':
        return SessionNextRevertCommitted.fromJson(json);
      case 'session.next.revert.staged':
        return SessionNextRevertStaged.fromJson(json);
      case 'session.next.shell.ended':
        return SessionNextShellEnded.fromJson(json);
      case 'session.next.shell.started':
        return SessionNextShellStarted.fromJson(json);
      case 'session.next.step.ended':
        return SessionNextStepEnded.fromJson(json);
      case 'session.next.step.failed':
        return SessionNextStepFailed.fromJson(json);
      case 'session.next.step.started':
        return SessionNextStepStarted.fromJson(json);
      case 'session.next.synthetic':
        return SessionNextSynthetic.fromJson(json);
      case 'session.next.text.delta':
        return SessionNextTextDelta.fromJson(json);
      case 'session.next.text.ended':
        return SessionNextTextEnded.fromJson(json);
      case 'session.next.text.started':
        return SessionNextTextStarted.fromJson(json);
      case 'session.next.tool.called':
        return SessionNextToolCalled.fromJson(json);
      case 'session.next.tool.failed':
        return SessionNextToolFailed.fromJson(json);
      case 'session.next.tool.input.delta':
        return SessionNextToolInputDelta.fromJson(json);
      case 'session.next.tool.input.ended':
        return SessionNextToolInputEnded.fromJson(json);
      case 'session.next.tool.input.started':
        return SessionNextToolInputStarted.fromJson(json);
      case 'session.next.tool.progress':
        return SessionNextToolProgress.fromJson(json);
      case 'session.next.tool.success':
        return SessionNextToolSuccess.fromJson(json);
      case 'session.status':
        return SessionStatus.fromJson(json);
      case 'session.updated':
        return SessionUpdated.fromJson(json);
      case 'todo.updated':
        return TodoUpdated.fromJson(json);
      case 'tui.command.execute':
        return TuiCommandExecute.fromJson(json);
      case 'tui.prompt.append':
        return TuiPromptAppend.fromJson(json);
      case 'tui.session.select':
        return TuiSessionSelect.fromJson(json);
      case 'tui.toast.show':
        return TuiToastShow.fromJson(json);
      case 'vcs.branch.updated':
        return VcsBranchUpdated.fromJson(json);
      case 'workspace.failed':
        return WorkspaceFailed.fromJson(json);
      case 'workspace.ready':
        return WorkspaceReady.fromJson(json);
      case 'workspace.status':
        return WorkspaceStatus.fromJson(json);
      case 'worktree.failed':
        return WorktreeFailed.fromJson(json);
      case 'worktree.ready':
        return WorktreeReady.fromJson(json);
      default:
        return UnknownEvent(json);
    }
  }
}

class CredentialValue {
  /// Диспетчеризация anyOf-вариантов по полю 'type'.
  static dynamic fromJson(Map<String, Object?> json) {
    final t = json['type'] as String?;
    switch (t) {
      case 'key':
        return CredentialKey.fromJson(json);
      case 'oauth':
        return CredentialOAuth.fromJson(json);
      default:
        return UnknownEvent(json);
    }
  }
}

class IntegrationMethod {
  /// Диспетчеризация anyOf-вариантов по полю 'type'.
  static dynamic fromJson(Map<String, Object?> json) {
    final t = json['type'] as String?;
    switch (t) {
      case 'env':
        return IntegrationEnvMethod.fromJson(json);
      case 'key':
        return IntegrationKeyMethod.fromJson(json);
      case 'oauth':
        return IntegrationOAuthMethod.fromJson(json);
      default:
        return UnknownEvent(json);
    }
  }
}

class SkillV2Source {
  /// Диспетчеризация anyOf-вариантов по полю 'type'.
  static dynamic fromJson(Map<String, Object?> json) {
    final t = json['type'] as String?;
    switch (t) {
      case 'directory':
        return SkillV2DirectorySource.fromJson(json);
      case 'embedded':
        return SkillV2EmbeddedSource.fromJson(json);
      case 'url':
        return SkillV2UrlSource.fromJson(json);
      default:
        return UnknownEvent(json);
    }
  }
}

class LLMToolContent {
  /// Диспетчеризация anyOf-вариантов по полю 'type'.
  static dynamic fromJson(Map<String, Object?> json) {
    final t = json['type'] as String?;
    switch (t) {
      case 'file':
        return ToolFileContent.fromJson(json);
      case 'text':
        return ToolTextContent.fromJson(json);
      default:
        return UnknownEvent(json);
    }
  }
}

class ProviderApi {
  /// Диспетчеризация anyOf-вариантов по полю 'type'.
  static dynamic fromJson(Map<String, Object?> json) {
    final t = json['type'] as String?;
    switch (t) {
      case 'aisdk':
        return ProviderAISDK.fromJson(json);
      case 'native':
        return ProviderNative.fromJson(json);
      default:
        return UnknownEvent(json);
    }
  }
}

class ConnectionInfo {
  /// Диспетчеризация anyOf-вариантов по полю 'type'.
  static dynamic fromJson(Map<String, Object?> json) {
    final t = json['type'] as String?;
    switch (t) {
      case 'credential':
        return ConnectionCredentialInfo.fromJson(json);
      case 'env':
        return ConnectionEnvInfo.fromJson(json);
      default:
        return UnknownEvent(json);
    }
  }
}

class ReferenceSource {
  /// Диспетчеризация anyOf-вариантов по полю 'type'.
  static dynamic fromJson(Map<String, Object?> json) {
    final t = json['type'] as String?;
    switch (t) {
      case 'git':
        return ReferenceGitSource.fromJson(json);
      case 'local':
        return ReferenceLocalSource.fromJson(json);
      default:
        return UnknownEvent(json);
    }
  }
}

class QuestionReplied {
  /// Создаёт модель из полей.
  QuestionReplied({
    required this.sessionID,
    required this.requestID,
    required this.answers,
  });
  final String sessionID;
  final String requestID;
  final List<String> answers;

  /// Разбирает JSON в [Object] типа QuestionReplied.
  factory QuestionReplied.fromJson(Map<String, Object?> json) {
    return QuestionReplied(
      sessionID: json['sessionID'] as String,
      requestID: json['requestID'] as String,
      answers: (json['answers'] as List).map((e) => e as String).toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'sessionID': sessionID,
    'requestID': requestID,
    'answers': answers,
  };
}

class QuestionRejected {
  /// Создаёт модель из полей.
  QuestionRejected({required this.sessionID, required this.requestID});
  final String sessionID;
  final String requestID;

  /// Разбирает JSON в [Object] типа QuestionRejected.
  factory QuestionRejected.fromJson(Map<String, Object?> json) {
    return QuestionRejected(
      sessionID: json['sessionID'] as String,
      requestID: json['requestID'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'sessionID': sessionID,
    'requestID': requestID,
  };
}

class OAuth {
  /// Создаёт модель из полей.
  OAuth({
    this.type,
    this.refresh,
    this.access,
    this.expires,
    this.accountId,
    this.enterpriseUrl,
  });
  final String? type;
  final String? refresh;
  final String? access;
  final int? expires;
  final String? accountId;
  final String? enterpriseUrl;

  /// Разбирает JSON в [Object] типа OAuth.
  factory OAuth.fromJson(Map<String, Object?> json) {
    return OAuth(
      type: json['type'] as String?,
      refresh: json['refresh'] as String?,
      access: json['access'] as String?,
      expires: (json['expires'] as num?)?.toInt(),
      accountId: json['accountId'] as String?,
      enterpriseUrl: json['enterpriseUrl'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'refresh': refresh,
    'access': access,
    'expires': expires,
    'accountId': accountId,
    'enterpriseUrl': enterpriseUrl,
  };
}

class ApiAuth {
  /// Создаёт модель из полей.
  ApiAuth({this.type, this.key, this.metadata});
  final String? type;
  final String? key;
  final Map<String, String>? metadata;

  /// Разбирает JSON в [Object] типа ApiAuth.
  factory ApiAuth.fromJson(Map<String, Object?> json) {
    return ApiAuth(
      type: json['type'] as String?,
      key: json['key'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v as String),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'key': key,
    'metadata': metadata,
  };
}

class WellKnownAuth {
  /// Создаёт модель из полей.
  WellKnownAuth({this.type, this.key, this.token});
  final String? type;
  final String? key;
  final String? token;

  /// Разбирает JSON в [Object] типа WellKnownAuth.
  factory WellKnownAuth.fromJson(Map<String, Object?> json) {
    return WellKnownAuth(
      type: json['type'] as String?,
      key: json['key'] as String?,
      token: json['token'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'type': type, 'key': key, 'token': token};
}

class EffectHttpApiErrorBadRequest {
  /// Создаёт модель из полей.
  EffectHttpApiErrorBadRequest({required this.tag});
  final String tag;

  /// Разбирает JSON в [Object] типа EffectHttpApiErrorBadRequest.
  factory EffectHttpApiErrorBadRequest.fromJson(Map<String, Object?> json) {
    return EffectHttpApiErrorBadRequest(tag: json['_tag'] as String);
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'_tag': tag};
}

class InvalidRequestError {
  /// Создаёт модель из полей.
  InvalidRequestError({
    required this.tag,
    required this.message,
    this.kind,
    this.field,
  });
  final String tag;
  final String message;
  final String? kind;
  final String? field;

  /// Разбирает JSON в [Object] типа InvalidRequestError.
  factory InvalidRequestError.fromJson(Map<String, Object?> json) {
    return InvalidRequestError(
      tag: json['_tag'] as String,
      message: json['message'] as String,
      kind: json['kind'] as String?,
      field: json['field'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    '_tag': tag,
    'message': message,
    'kind': kind,
    'field': field,
  };
}

class MoveSessionError {
  /// Создаёт модель из полей.
  MoveSessionError({required this.name, required this.data});
  final String name;
  final Map<String, dynamic> data;

  /// Разбирает JSON в [Object] типа MoveSessionError.
  factory MoveSessionError.fromJson(Map<String, Object?> json) {
    return MoveSessionError(
      name: json['name'] as String,
      data: (json['data'] as Map).map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'name': name, 'data': data};
}

class SnapshotFileDiff {
  /// Создаёт модель из полей.
  SnapshotFileDiff({
    this.file,
    this.patch,
    required this.additions,
    required this.deletions,
    this.status,
  });
  final String? file;
  final String? patch;
  final double additions;
  final double deletions;
  final String? status;

  /// Разбирает JSON в [Object] типа SnapshotFileDiff.
  factory SnapshotFileDiff.fromJson(Map<String, Object?> json) {
    return SnapshotFileDiff(
      file: json['file'] as String?,
      patch: json['patch'] as String?,
      additions: (json['additions'] as num).toDouble(),
      deletions: (json['deletions'] as num).toDouble(),
      status: json['status'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'file': file,
    'patch': patch,
    'additions': additions,
    'deletions': deletions,
    'status': status,
  };
}

class PermissionRule {
  /// Создаёт модель из полей.
  PermissionRule({
    required this.permission,
    required this.pattern,
    required this.action,
  });
  final String permission;
  final String pattern;
  final String action;

  /// Разбирает JSON в [Object] типа PermissionRule.
  factory PermissionRule.fromJson(Map<String, Object?> json) {
    return PermissionRule(
      permission: json['permission'] as String,
      pattern: json['pattern'] as String,
      action: json['action'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'permission': permission,
    'pattern': pattern,
    'action': action,
  };
}

class Session {
  /// Создаёт модель из полей.
  Session({
    required this.id,
    required this.slug,
    required this.projectID,
    this.workspaceID,
    required this.directory,
    this.path,
    this.parentID,
    this.summary,
    this.cost,
    this.tokens,
    this.share,
    required this.title,
    this.agent,
    this.model,
    required this.version,
    this.metadata,
    required this.time,
    this.permission,
    this.revert,
  });
  final String id;
  final String slug;
  final String projectID;
  final String? workspaceID;
  final String directory;
  final String? path;
  final String? parentID;
  final Map<String, dynamic>? summary;
  final double? cost;
  final Map<String, dynamic>? tokens;
  final Map<String, dynamic>? share;
  final String title;
  final String? agent;
  final Map<String, dynamic>? model;
  final String version;
  final Map<String, dynamic>? metadata;
  final Map<String, dynamic> time;
  final PermissionRule? permission;
  final Map<String, dynamic>? revert;

  /// Разбирает JSON в [Object] типа Session.
  factory Session.fromJson(Map<String, Object?> json) {
    return Session(
      id: json['id'] as String,
      slug: json['slug'] as String,
      projectID: json['projectID'] as String,
      workspaceID: json['workspaceID'] as String?,
      directory: json['directory'] as String,
      path: json['path'] as String?,
      parentID: json['parentID'] as String?,
      summary: (json['summary'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      cost: (json['cost'] as num?)?.toDouble(),
      tokens: (json['tokens'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      share: (json['share'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      title: json['title'] as String,
      agent: json['agent'] as String?,
      model: (json['model'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      version: json['version'] as String,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      time: (json['time'] as Map).map((k, v) => MapEntry(k as String, v)),
      permission: (json['permission'] as Map<String, Object?>?) == null
          ? null
          : PermissionRule.fromJson(json['permission'] as Map<String, Object?>),
      revert: (json['revert'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'slug': slug,
    'projectID': projectID,
    'workspaceID': workspaceID,
    'directory': directory,
    'path': path,
    'parentID': parentID,
    'summary': summary,
    'cost': cost,
    'tokens': tokens,
    'share': share,
    'title': title,
    'agent': agent,
    'model': model,
    'version': version,
    'metadata': metadata,
    'time': time,
    'permission': permission?.toJson(),
    'revert': revert,
  };
}

class OutputFormatText {
  /// Создаёт модель из полей.
  OutputFormatText({this.type});
  final String? type;

  /// Разбирает JSON в [Object] типа OutputFormatText.
  factory OutputFormatText.fromJson(Map<String, Object?> json) {
    return OutputFormatText(type: json['type'] as String?);
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'type': type};
}

class OutputFormatJsonSchema {
  /// Создаёт модель из полей.
  OutputFormatJsonSchema({this.type, this.schema, this.retryCount});
  final String? type;
  final Map<String, dynamic>? schema;
  final int? retryCount;

  /// Разбирает JSON в [Object] типа OutputFormatJsonSchema.
  factory OutputFormatJsonSchema.fromJson(Map<String, Object?> json) {
    return OutputFormatJsonSchema(
      type: json['type'] as String?,
      schema: (json['schema'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      retryCount: (json['retryCount'] as num?)?.toInt(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'schema': schema,
    'retryCount': retryCount,
  };
}

class UserMessage {
  /// Создаёт модель из полей.
  UserMessage({
    this.id,
    this.sessionID,
    this.role,
    this.time,
    this.format,
    this.summary,
    this.agent,
    this.model,
    this.system,
    this.tools,
  });
  final String? id;
  final String? sessionID;
  final String? role;
  final Map<String, dynamic>? time;
  final dynamic format;
  final Map<String, dynamic>? summary;
  final String? agent;
  final Map<String, dynamic>? model;
  final String? system;
  final Map<String, bool>? tools;

  /// Разбирает JSON в [Object] типа UserMessage.
  factory UserMessage.fromJson(Map<String, Object?> json) {
    return UserMessage(
      id: json['id'] as String?,
      sessionID: json['sessionID'] as String?,
      role: json['role'] as String?,
      time: (json['time'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      format: json['format'],
      summary: (json['summary'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      agent: json['agent'] as String?,
      model: (json['model'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      system: json['system'] as String?,
      tools: (json['tools'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v as bool),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'sessionID': sessionID,
    'role': role,
    'time': time,
    'format': format,
    'summary': summary,
    'agent': agent,
    'model': model,
    'system': system,
    'tools': tools,
  };
}

class ProviderAuthError {
  /// Создаёт модель из полей.
  ProviderAuthError({required this.name, required this.data});
  final String name;
  final Map<String, dynamic> data;

  /// Разбирает JSON в [Object] типа ProviderAuthError.
  factory ProviderAuthError.fromJson(Map<String, Object?> json) {
    return ProviderAuthError(
      name: json['name'] as String,
      data: (json['data'] as Map).map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'name': name, 'data': data};
}

class UnknownError {
  /// Создаёт модель из полей.
  UnknownError({required this.name, required this.data});
  final String name;
  final Map<String, dynamic> data;

  /// Разбирает JSON в [Object] типа UnknownError.
  factory UnknownError.fromJson(Map<String, Object?> json) {
    return UnknownError(
      name: json['name'] as String,
      data: (json['data'] as Map).map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'name': name, 'data': data};
}

class MessageOutputLengthError {
  /// Создаёт модель из полей.
  MessageOutputLengthError({required this.name, required this.data});
  final String name;
  final Map<String, dynamic> data;

  /// Разбирает JSON в [Object] типа MessageOutputLengthError.
  factory MessageOutputLengthError.fromJson(Map<String, Object?> json) {
    return MessageOutputLengthError(
      name: json['name'] as String,
      data: (json['data'] as Map).map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'name': name, 'data': data};
}

class MessageAbortedError {
  /// Создаёт модель из полей.
  MessageAbortedError({required this.name, required this.data});
  final String name;
  final Map<String, dynamic> data;

  /// Разбирает JSON в [Object] типа MessageAbortedError.
  factory MessageAbortedError.fromJson(Map<String, Object?> json) {
    return MessageAbortedError(
      name: json['name'] as String,
      data: (json['data'] as Map).map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'name': name, 'data': data};
}

class StructuredOutputError {
  /// Создаёт модель из полей.
  StructuredOutputError({required this.name, required this.data});
  final String name;
  final Map<String, dynamic> data;

  /// Разбирает JSON в [Object] типа StructuredOutputError.
  factory StructuredOutputError.fromJson(Map<String, Object?> json) {
    return StructuredOutputError(
      name: json['name'] as String,
      data: (json['data'] as Map).map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'name': name, 'data': data};
}

class ContextOverflowError {
  /// Создаёт модель из полей.
  ContextOverflowError({required this.name, required this.data});
  final String name;
  final Map<String, dynamic> data;

  /// Разбирает JSON в [Object] типа ContextOverflowError.
  factory ContextOverflowError.fromJson(Map<String, Object?> json) {
    return ContextOverflowError(
      name: json['name'] as String,
      data: (json['data'] as Map).map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'name': name, 'data': data};
}

class ContentFilterError {
  /// Создаёт модель из полей.
  ContentFilterError({required this.name, required this.data});
  final String name;
  final Map<String, dynamic> data;

  /// Разбирает JSON в [Object] типа ContentFilterError.
  factory ContentFilterError.fromJson(Map<String, Object?> json) {
    return ContentFilterError(
      name: json['name'] as String,
      data: (json['data'] as Map).map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'name': name, 'data': data};
}

class APIError {
  /// Создаёт модель из полей.
  APIError({required this.name, required this.data});
  final String name;
  final Map<String, dynamic> data;

  /// Разбирает JSON в [Object] типа APIError.
  factory APIError.fromJson(Map<String, Object?> json) {
    return APIError(
      name: json['name'] as String,
      data: (json['data'] as Map).map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'name': name, 'data': data};
}

class AssistantMessage {
  /// Создаёт модель из полей.
  AssistantMessage({
    this.id,
    this.sessionID,
    this.role,
    this.time,
    this.error,
    this.parentID,
    this.modelID,
    this.providerID,
    this.mode,
    this.agent,
    this.path,
    this.summary,
    this.cost,
    this.tokens,
    this.structured,
    this.variant,
    this.finish,
  });
  final String? id;
  final String? sessionID;
  final String? role;
  final Map<String, dynamic>? time;
  final dynamic error;
  final String? parentID;
  final String? modelID;
  final String? providerID;
  final String? mode;
  final String? agent;
  final Map<String, dynamic>? path;
  final bool? summary;
  final double? cost;
  final Map<String, dynamic>? tokens;
  final dynamic structured;
  final String? variant;
  final String? finish;

  /// Разбирает JSON в [Object] типа AssistantMessage.
  factory AssistantMessage.fromJson(Map<String, Object?> json) {
    return AssistantMessage(
      id: json['id'] as String?,
      sessionID: json['sessionID'] as String?,
      role: json['role'] as String?,
      time: (json['time'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      error: json['error'],
      parentID: json['parentID'] as String?,
      modelID: json['modelID'] as String?,
      providerID: json['providerID'] as String?,
      mode: json['mode'] as String?,
      agent: json['agent'] as String?,
      path: (json['path'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      summary: json['summary'] as bool?,
      cost: (json['cost'] as num?)?.toDouble(),
      tokens: (json['tokens'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      structured: json['structured'],
      variant: json['variant'] as String?,
      finish: json['finish'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'sessionID': sessionID,
    'role': role,
    'time': time,
    'error': error,
    'parentID': parentID,
    'modelID': modelID,
    'providerID': providerID,
    'mode': mode,
    'agent': agent,
    'path': path,
    'summary': summary,
    'cost': cost,
    'tokens': tokens,
    'structured': structured,
    'variant': variant,
    'finish': finish,
  };
}

class TextPart {
  /// Создаёт модель из полей.
  TextPart({
    this.id,
    this.sessionID,
    this.messageID,
    this.type,
    this.text,
    this.synthetic,
    this.ignored,
    this.time,
    this.metadata,
  });
  final String? id;
  final String? sessionID;
  final String? messageID;
  final String? type;
  final String? text;
  final bool? synthetic;
  final bool? ignored;
  final Map<String, dynamic>? time;
  final Map<String, dynamic>? metadata;

  /// Разбирает JSON в [Object] типа TextPart.
  factory TextPart.fromJson(Map<String, Object?> json) {
    return TextPart(
      id: json['id'] as String?,
      sessionID: json['sessionID'] as String?,
      messageID: json['messageID'] as String?,
      type: json['type'] as String?,
      text: json['text'] as String?,
      synthetic: json['synthetic'] as bool?,
      ignored: json['ignored'] as bool?,
      time: (json['time'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'sessionID': sessionID,
    'messageID': messageID,
    'type': type,
    'text': text,
    'synthetic': synthetic,
    'ignored': ignored,
    'time': time,
    'metadata': metadata,
  };
}

class SubtaskPart {
  /// Создаёт модель из полей.
  SubtaskPart({
    this.id,
    this.sessionID,
    this.messageID,
    this.type,
    this.prompt,
    this.description,
    this.agent,
    this.model,
    this.command,
  });
  final String? id;
  final String? sessionID;
  final String? messageID;
  final String? type;
  final String? prompt;
  final String? description;
  final String? agent;
  final Map<String, dynamic>? model;
  final String? command;

  /// Разбирает JSON в [Object] типа SubtaskPart.
  factory SubtaskPart.fromJson(Map<String, Object?> json) {
    return SubtaskPart(
      id: json['id'] as String?,
      sessionID: json['sessionID'] as String?,
      messageID: json['messageID'] as String?,
      type: json['type'] as String?,
      prompt: json['prompt'] as String?,
      description: json['description'] as String?,
      agent: json['agent'] as String?,
      model: (json['model'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      command: json['command'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'sessionID': sessionID,
    'messageID': messageID,
    'type': type,
    'prompt': prompt,
    'description': description,
    'agent': agent,
    'model': model,
    'command': command,
  };
}

class ReasoningPart {
  /// Создаёт модель из полей.
  ReasoningPart({
    this.id,
    this.sessionID,
    this.messageID,
    this.type,
    this.text,
    this.metadata,
    this.time,
  });
  final String? id;
  final String? sessionID;
  final String? messageID;
  final String? type;
  final String? text;
  final Map<String, dynamic>? metadata;
  final Map<String, dynamic>? time;

  /// Разбирает JSON в [Object] типа ReasoningPart.
  factory ReasoningPart.fromJson(Map<String, Object?> json) {
    return ReasoningPart(
      id: json['id'] as String?,
      sessionID: json['sessionID'] as String?,
      messageID: json['messageID'] as String?,
      type: json['type'] as String?,
      text: json['text'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      time: (json['time'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'sessionID': sessionID,
    'messageID': messageID,
    'type': type,
    'text': text,
    'metadata': metadata,
    'time': time,
  };
}

class FilePartSourceText {
  /// Создаёт модель из полей.
  FilePartSourceText({
    required this.value,
    required this.start,
    required this.end,
  });
  final String value;
  final double start;
  final double end;

  /// Разбирает JSON в [Object] типа FilePartSourceText.
  factory FilePartSourceText.fromJson(Map<String, Object?> json) {
    return FilePartSourceText(
      value: json['value'] as String,
      start: (json['start'] as num).toDouble(),
      end: (json['end'] as num).toDouble(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'value': value, 'start': start, 'end': end};
}

class FileSource {
  /// Создаёт модель из полей.
  FileSource({this.text, this.type, this.path});
  final FilePartSourceText? text;
  final String? type;
  final String? path;

  /// Разбирает JSON в [Object] типа FileSource.
  factory FileSource.fromJson(Map<String, Object?> json) {
    return FileSource(
      text: (json['text'] as Map<String, Object?>?) == null
          ? null
          : FilePartSourceText.fromJson(json['text'] as Map<String, Object?>),
      type: json['type'] as String?,
      path: json['path'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'text': text?.toJson(),
    'type': type,
    'path': path,
  };
}

class Range {
  /// Создаёт модель из полей.
  Range({required this.start, required this.end});
  final Map<String, dynamic> start;
  final Map<String, dynamic> end;

  /// Разбирает JSON в [Object] типа Range.
  factory Range.fromJson(Map<String, Object?> json) {
    return Range(
      start: (json['start'] as Map).map((k, v) => MapEntry(k as String, v)),
      end: (json['end'] as Map).map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'start': start, 'end': end};
}

class SymbolSource {
  /// Создаёт модель из полей.
  SymbolSource({
    this.text,
    this.type,
    this.path,
    this.range,
    this.name,
    this.kind,
  });
  final FilePartSourceText? text;
  final String? type;
  final String? path;
  final Range? range;
  final String? name;
  final int? kind;

  /// Разбирает JSON в [Object] типа SymbolSource.
  factory SymbolSource.fromJson(Map<String, Object?> json) {
    return SymbolSource(
      text: (json['text'] as Map<String, Object?>?) == null
          ? null
          : FilePartSourceText.fromJson(json['text'] as Map<String, Object?>),
      type: json['type'] as String?,
      path: json['path'] as String?,
      range: (json['range'] as Map<String, Object?>?) == null
          ? null
          : Range.fromJson(json['range'] as Map<String, Object?>),
      name: json['name'] as String?,
      kind: (json['kind'] as num?)?.toInt(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'text': text?.toJson(),
    'type': type,
    'path': path,
    'range': range?.toJson(),
    'name': name,
    'kind': kind,
  };
}

class ResourceSource {
  /// Создаёт модель из полей.
  ResourceSource({this.text, this.type, this.clientName, this.uri});
  final FilePartSourceText? text;
  final String? type;
  final String? clientName;
  final String? uri;

  /// Разбирает JSON в [Object] типа ResourceSource.
  factory ResourceSource.fromJson(Map<String, Object?> json) {
    return ResourceSource(
      text: (json['text'] as Map<String, Object?>?) == null
          ? null
          : FilePartSourceText.fromJson(json['text'] as Map<String, Object?>),
      type: json['type'] as String?,
      clientName: json['clientName'] as String?,
      uri: json['uri'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'text': text?.toJson(),
    'type': type,
    'clientName': clientName,
    'uri': uri,
  };
}

class FilePart {
  /// Создаёт модель из полей.
  FilePart({
    this.id,
    this.sessionID,
    this.messageID,
    this.type,
    this.mime,
    this.filename,
    this.url,
    this.source,
  });
  final String? id;
  final String? sessionID;
  final String? messageID;
  final String? type;
  final String? mime;
  final String? filename;
  final String? url;
  final dynamic source;

  /// Разбирает JSON в [Object] типа FilePart.
  factory FilePart.fromJson(Map<String, Object?> json) {
    return FilePart(
      id: json['id'] as String?,
      sessionID: json['sessionID'] as String?,
      messageID: json['messageID'] as String?,
      type: json['type'] as String?,
      mime: json['mime'] as String?,
      filename: json['filename'] as String?,
      url: json['url'] as String?,
      source: json['source'],
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'sessionID': sessionID,
    'messageID': messageID,
    'type': type,
    'mime': mime,
    'filename': filename,
    'url': url,
    'source': source,
  };
}

class ToolStatePending {
  /// Создаёт модель из полей.
  ToolStatePending({this.status, this.input, this.raw});
  final String? status;
  final Map<String, dynamic>? input;
  final String? raw;

  /// Разбирает JSON в [Object] типа ToolStatePending.
  factory ToolStatePending.fromJson(Map<String, Object?> json) {
    return ToolStatePending(
      status: json['status'] as String?,
      input: (json['input'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      raw: json['raw'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'status': status,
    'input': input,
    'raw': raw,
  };
}

class ToolStateRunning {
  /// Создаёт модель из полей.
  ToolStateRunning({
    this.status,
    this.input,
    this.title,
    this.metadata,
    this.time,
  });
  final String? status;
  final Map<String, dynamic>? input;
  final String? title;
  final Map<String, dynamic>? metadata;
  final Map<String, dynamic>? time;

  /// Разбирает JSON в [Object] типа ToolStateRunning.
  factory ToolStateRunning.fromJson(Map<String, Object?> json) {
    return ToolStateRunning(
      status: json['status'] as String?,
      input: (json['input'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      title: json['title'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      time: (json['time'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'status': status,
    'input': input,
    'title': title,
    'metadata': metadata,
    'time': time,
  };
}

class ToolStateCompleted {
  /// Создаёт модель из полей.
  ToolStateCompleted({
    this.status,
    this.input,
    this.output,
    this.title,
    this.metadata,
    this.time,
    this.attachments,
  });
  final String? status;
  final Map<String, dynamic>? input;
  final String? output;
  final String? title;
  final Map<String, dynamic>? metadata;
  final Map<String, dynamic>? time;
  final List<FilePart>? attachments;

  /// Разбирает JSON в [Object] типа ToolStateCompleted.
  factory ToolStateCompleted.fromJson(Map<String, Object?> json) {
    return ToolStateCompleted(
      status: json['status'] as String?,
      input: (json['input'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      output: json['output'] as String?,
      title: json['title'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      time: (json['time'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      attachments: (json['attachments'] as List?)
          ?.map((e) => FilePart.fromJson(e as Map<String, Object?>))
          .toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'status': status,
    'input': input,
    'output': output,
    'title': title,
    'metadata': metadata,
    'time': time,
    'attachments': attachments?.map((e) => e.toJson()).toList(),
  };
}

class ToolStateError {
  /// Создаёт модель из полей.
  ToolStateError({
    this.status,
    this.input,
    this.error,
    this.metadata,
    this.time,
  });
  final String? status;
  final Map<String, dynamic>? input;
  final String? error;
  final Map<String, dynamic>? metadata;
  final Map<String, dynamic>? time;

  /// Разбирает JSON в [Object] типа ToolStateError.
  factory ToolStateError.fromJson(Map<String, Object?> json) {
    return ToolStateError(
      status: json['status'] as String?,
      input: (json['input'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      error: json['error'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      time: (json['time'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'status': status,
    'input': input,
    'error': error,
    'metadata': metadata,
    'time': time,
  };
}

class ToolPart {
  /// Создаёт модель из полей.
  ToolPart({
    this.id,
    this.sessionID,
    this.messageID,
    this.type,
    this.callID,
    this.tool,
    this.state,
    this.metadata,
  });
  final String? id;
  final String? sessionID;
  final String? messageID;
  final String? type;
  final String? callID;
  final String? tool;
  final dynamic state;
  final Map<String, dynamic>? metadata;

  /// Разбирает JSON в [Object] типа ToolPart.
  factory ToolPart.fromJson(Map<String, Object?> json) {
    return ToolPart(
      id: json['id'] as String?,
      sessionID: json['sessionID'] as String?,
      messageID: json['messageID'] as String?,
      type: json['type'] as String?,
      callID: json['callID'] as String?,
      tool: json['tool'] as String?,
      state: json['state'],
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'sessionID': sessionID,
    'messageID': messageID,
    'type': type,
    'callID': callID,
    'tool': tool,
    'state': state,
    'metadata': metadata,
  };
}

class StepStartPart {
  /// Создаёт модель из полей.
  StepStartPart({
    this.id,
    this.sessionID,
    this.messageID,
    this.type,
    this.snapshot,
  });
  final String? id;
  final String? sessionID;
  final String? messageID;
  final String? type;
  final String? snapshot;

  /// Разбирает JSON в [Object] типа StepStartPart.
  factory StepStartPart.fromJson(Map<String, Object?> json) {
    return StepStartPart(
      id: json['id'] as String?,
      sessionID: json['sessionID'] as String?,
      messageID: json['messageID'] as String?,
      type: json['type'] as String?,
      snapshot: json['snapshot'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'sessionID': sessionID,
    'messageID': messageID,
    'type': type,
    'snapshot': snapshot,
  };
}

class StepFinishPart {
  /// Создаёт модель из полей.
  StepFinishPart({
    this.id,
    this.sessionID,
    this.messageID,
    this.type,
    this.reason,
    this.snapshot,
    this.cost,
    this.tokens,
  });
  final String? id;
  final String? sessionID;
  final String? messageID;
  final String? type;
  final String? reason;
  final String? snapshot;
  final double? cost;
  final Map<String, dynamic>? tokens;

  /// Разбирает JSON в [Object] типа StepFinishPart.
  factory StepFinishPart.fromJson(Map<String, Object?> json) {
    return StepFinishPart(
      id: json['id'] as String?,
      sessionID: json['sessionID'] as String?,
      messageID: json['messageID'] as String?,
      type: json['type'] as String?,
      reason: json['reason'] as String?,
      snapshot: json['snapshot'] as String?,
      cost: (json['cost'] as num?)?.toDouble(),
      tokens: (json['tokens'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'sessionID': sessionID,
    'messageID': messageID,
    'type': type,
    'reason': reason,
    'snapshot': snapshot,
    'cost': cost,
    'tokens': tokens,
  };
}

class SnapshotPart {
  /// Создаёт модель из полей.
  SnapshotPart({
    this.id,
    this.sessionID,
    this.messageID,
    this.type,
    this.snapshot,
  });
  final String? id;
  final String? sessionID;
  final String? messageID;
  final String? type;
  final String? snapshot;

  /// Разбирает JSON в [Object] типа SnapshotPart.
  factory SnapshotPart.fromJson(Map<String, Object?> json) {
    return SnapshotPart(
      id: json['id'] as String?,
      sessionID: json['sessionID'] as String?,
      messageID: json['messageID'] as String?,
      type: json['type'] as String?,
      snapshot: json['snapshot'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'sessionID': sessionID,
    'messageID': messageID,
    'type': type,
    'snapshot': snapshot,
  };
}

class PatchPart {
  /// Создаёт модель из полей.
  PatchPart({
    this.id,
    this.sessionID,
    this.messageID,
    this.type,
    this.hash,
    this.files,
  });
  final String? id;
  final String? sessionID;
  final String? messageID;
  final String? type;
  final String? hash;
  final List<String>? files;

  /// Разбирает JSON в [Object] типа PatchPart.
  factory PatchPart.fromJson(Map<String, Object?> json) {
    return PatchPart(
      id: json['id'] as String?,
      sessionID: json['sessionID'] as String?,
      messageID: json['messageID'] as String?,
      type: json['type'] as String?,
      hash: json['hash'] as String?,
      files: (json['files'] as List?)?.map((e) => e as String).toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'sessionID': sessionID,
    'messageID': messageID,
    'type': type,
    'hash': hash,
    'files': files,
  };
}

class AgentPart {
  /// Создаёт модель из полей.
  AgentPart({
    this.id,
    this.sessionID,
    this.messageID,
    this.type,
    this.name,
    this.source,
  });
  final String? id;
  final String? sessionID;
  final String? messageID;
  final String? type;
  final String? name;
  final Map<String, dynamic>? source;

  /// Разбирает JSON в [Object] типа AgentPart.
  factory AgentPart.fromJson(Map<String, Object?> json) {
    return AgentPart(
      id: json['id'] as String?,
      sessionID: json['sessionID'] as String?,
      messageID: json['messageID'] as String?,
      type: json['type'] as String?,
      name: json['name'] as String?,
      source: (json['source'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'sessionID': sessionID,
    'messageID': messageID,
    'type': type,
    'name': name,
    'source': source,
  };
}

class RetryPart {
  /// Создаёт модель из полей.
  RetryPart({
    this.id,
    this.sessionID,
    this.messageID,
    this.type,
    this.attempt,
    this.error,
    this.time,
  });
  final String? id;
  final String? sessionID;
  final String? messageID;
  final String? type;
  final int? attempt;
  final APIError? error;
  final Map<String, dynamic>? time;

  /// Разбирает JSON в [Object] типа RetryPart.
  factory RetryPart.fromJson(Map<String, Object?> json) {
    return RetryPart(
      id: json['id'] as String?,
      sessionID: json['sessionID'] as String?,
      messageID: json['messageID'] as String?,
      type: json['type'] as String?,
      attempt: (json['attempt'] as num?)?.toInt(),
      error: (json['error'] as Map<String, Object?>?) == null
          ? null
          : APIError.fromJson(json['error'] as Map<String, Object?>),
      time: (json['time'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'sessionID': sessionID,
    'messageID': messageID,
    'type': type,
    'attempt': attempt,
    'error': error?.toJson(),
    'time': time,
  };
}

class CompactionPart {
  /// Создаёт модель из полей.
  CompactionPart({
    this.id,
    this.sessionID,
    this.messageID,
    this.type,
    this.auto,
    this.overflow,
    this.tail_start_id,
  });
  final String? id;
  final String? sessionID;
  final String? messageID;
  final String? type;
  final bool? auto;
  final bool? overflow;
  final String? tail_start_id;

  /// Разбирает JSON в [Object] типа CompactionPart.
  factory CompactionPart.fromJson(Map<String, Object?> json) {
    return CompactionPart(
      id: json['id'] as String?,
      sessionID: json['sessionID'] as String?,
      messageID: json['messageID'] as String?,
      type: json['type'] as String?,
      auto: json['auto'] as bool?,
      overflow: json['overflow'] as bool?,
      tail_start_id: json['tail_start_id'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'sessionID': sessionID,
    'messageID': messageID,
    'type': type,
    'auto': auto,
    'overflow': overflow,
    'tail_start_id': tail_start_id,
  };
}

class PromptSource {
  /// Создаёт модель из полей.
  PromptSource({required this.start, required this.end, required this.text});
  final double start;
  final double end;
  final String text;

  /// Разбирает JSON в [Object] типа PromptSource.
  factory PromptSource.fromJson(Map<String, Object?> json) {
    return PromptSource(
      start: (json['start'] as num).toDouble(),
      end: (json['end'] as num).toDouble(),
      text: json['text'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'start': start, 'end': end, 'text': text};
}

class PromptFileAttachment {
  /// Создаёт модель из полей.
  PromptFileAttachment({
    required this.uri,
    required this.mime,
    this.name,
    this.description,
    this.source,
  });
  final String uri;
  final String mime;
  final String? name;
  final String? description;
  final PromptSource? source;

  /// Разбирает JSON в [Object] типа PromptFileAttachment.
  factory PromptFileAttachment.fromJson(Map<String, Object?> json) {
    return PromptFileAttachment(
      uri: json['uri'] as String,
      mime: json['mime'] as String,
      name: json['name'] as String?,
      description: json['description'] as String?,
      source: (json['source'] as Map<String, Object?>?) == null
          ? null
          : PromptSource.fromJson(json['source'] as Map<String, Object?>),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'uri': uri,
    'mime': mime,
    'name': name,
    'description': description,
    'source': source?.toJson(),
  };
}

class PromptAgentAttachment {
  /// Создаёт модель из полей.
  PromptAgentAttachment({required this.name, this.source});
  final String name;
  final PromptSource? source;

  /// Разбирает JSON в [Object] типа PromptAgentAttachment.
  factory PromptAgentAttachment.fromJson(Map<String, Object?> json) {
    return PromptAgentAttachment(
      name: json['name'] as String,
      source: (json['source'] as Map<String, Object?>?) == null
          ? null
          : PromptSource.fromJson(json['source'] as Map<String, Object?>),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'name': name, 'source': source?.toJson()};
}

class Prompt {
  /// Создаёт модель из полей.
  Prompt({required this.text, this.files, this.agents});
  final String text;
  final List<PromptFileAttachment>? files;
  final List<PromptAgentAttachment>? agents;

  /// Разбирает JSON в [Object] типа Prompt.
  factory Prompt.fromJson(Map<String, Object?> json) {
    return Prompt(
      text: json['text'] as String,
      files: (json['files'] as List?)
          ?.map((e) => PromptFileAttachment.fromJson(e as Map<String, Object?>))
          .toList(),
      agents: (json['agents'] as List?)
          ?.map(
            (e) => PromptAgentAttachment.fromJson(e as Map<String, Object?>),
          )
          .toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'text': text,
    'files': files?.map((e) => e.toJson()).toList(),
    'agents': agents?.map((e) => e.toJson()).toList(),
  };
}

class Pty {
  /// Создаёт модель из полей.
  Pty({
    required this.id,
    required this.title,
    required this.command,
    required this.args,
    required this.cwd,
    required this.status,
    required this.pid,
    this.exitCode,
  });
  final String id;
  final String title;
  final String command;
  final List<String> args;
  final String cwd;
  final String status;
  final int pid;
  final int? exitCode;

  /// Разбирает JSON в [Object] типа Pty.
  factory Pty.fromJson(Map<String, Object?> json) {
    return Pty(
      id: json['id'] as String,
      title: json['title'] as String,
      command: json['command'] as String,
      args: (json['args'] as List).map((e) => e as String).toList(),
      cwd: json['cwd'] as String,
      status: json['status'] as String,
      pid: (json['pid'] as num).toInt(),
      exitCode: (json['exitCode'] as num?)?.toInt(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'command': command,
    'args': args,
    'cwd': cwd,
    'status': status,
    'pid': pid,
    'exitCode': exitCode,
  };
}

class Todo {
  /// Создаёт модель из полей.
  Todo({required this.content, required this.status, required this.priority});
  final String content;
  final String status;
  final String priority;

  /// Разбирает JSON в [Object] типа Todo.
  factory Todo.fromJson(Map<String, Object?> json) {
    return Todo(
      content: json['content'] as String,
      status: json['status'] as String,
      priority: json['priority'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'content': content,
    'status': status,
    'priority': priority,
  };
}

class QuestionOption {
  /// Создаёт модель из полей.
  QuestionOption({required this.label, required this.description});
  final String label;
  final String description;

  /// Разбирает JSON в [Object] типа QuestionOption.
  factory QuestionOption.fromJson(Map<String, Object?> json) {
    return QuestionOption(
      label: json['label'] as String,
      description: json['description'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'label': label, 'description': description};
}

class QuestionInfo {
  /// Создаёт модель из полей.
  QuestionInfo({
    required this.question,
    required this.header,
    required this.options,
    this.multiple,
    this.custom,
  });
  final String question;
  final String header;
  final List<QuestionOption> options;
  final bool? multiple;
  final bool? custom;

  /// Разбирает JSON в [Object] типа QuestionInfo.
  factory QuestionInfo.fromJson(Map<String, Object?> json) {
    return QuestionInfo(
      question: json['question'] as String,
      header: json['header'] as String,
      options: (json['options'] as List)
          .map((e) => QuestionOption.fromJson(e as Map<String, Object?>))
          .toList(),
      multiple: json['multiple'] as bool?,
      custom: json['custom'] as bool?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'question': question,
    'header': header,
    'options': options?.map((e) => e.toJson()).toList(),
    'multiple': multiple,
    'custom': custom,
  };
}

class QuestionTool {
  /// Создаёт модель из полей.
  QuestionTool({required this.messageID, required this.callID});
  final String messageID;
  final String callID;

  /// Разбирает JSON в [Object] типа QuestionTool.
  factory QuestionTool.fromJson(Map<String, Object?> json) {
    return QuestionTool(
      messageID: json['messageID'] as String,
      callID: json['callID'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'messageID': messageID, 'callID': callID};
}

class GlobalEvent {
  /// Создаёт модель из полей.
  GlobalEvent({
    required this.directory,
    this.project,
    this.workspace,
    required this.payload,
  });
  final String directory;
  final String? project;
  final String? workspace;
  final dynamic payload;

  /// Разбирает JSON в [Object] типа GlobalEvent.
  factory GlobalEvent.fromJson(Map<String, Object?> json) {
    return GlobalEvent(
      directory: json['directory'] as String,
      project: json['project'] as String?,
      workspace: json['workspace'] as String?,
      payload: json['payload'],
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'directory': directory,
    'project': project,
    'workspace': workspace,
    'payload': payload,
  };
}

class ServerConfig {
  /// Создаёт модель из полей.
  ServerConfig({
    this.port,
    this.hostname,
    this.mdns,
    this.mdnsDomain,
    this.cors,
  });
  final int? port;
  final String? hostname;
  final bool? mdns;
  final String? mdnsDomain;
  final List<String>? cors;

  /// Разбирает JSON в [Object] типа ServerConfig.
  factory ServerConfig.fromJson(Map<String, Object?> json) {
    return ServerConfig(
      port: (json['port'] as num?)?.toInt(),
      hostname: json['hostname'] as String?,
      mdns: json['mdns'] as bool?,
      mdnsDomain: json['mdnsDomain'] as String?,
      cors: (json['cors'] as List?)?.map((e) => e as String).toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'port': port,
    'hostname': hostname,
    'mdns': mdns,
    'mdnsDomain': mdnsDomain,
    'cors': cors,
  };
}

class AgentConfig {
  /// Создаёт модель из полей.
  AgentConfig({
    this.model,
    this.variant,
    this.temperature,
    this.top_p,
    this.prompt,
    this.tools,
    this.disable,
    this.description,
    this.mode,
    this.hidden,
    this.options,
    this.color,
    this.steps,
    this.maxSteps,
    this.permission,
  });
  final String? model;
  final String? variant;
  final double? temperature;
  final double? top_p;
  final String? prompt;
  final Map<String, bool>? tools;
  final bool? disable;
  final String? description;
  final String? mode;
  final bool? hidden;
  final Map<String, dynamic>? options;
  final dynamic color;
  final int? steps;
  final int? maxSteps;
  final dynamic permission;

  /// Разбирает JSON в [Object] типа AgentConfig.
  factory AgentConfig.fromJson(Map<String, Object?> json) {
    return AgentConfig(
      model: json['model'] as String?,
      variant: json['variant'] as String?,
      temperature: (json['temperature'] as num?)?.toDouble(),
      top_p: (json['top_p'] as num?)?.toDouble(),
      prompt: json['prompt'] as String?,
      tools: (json['tools'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v as bool),
      ),
      disable: json['disable'] as bool?,
      description: json['description'] as String?,
      mode: json['mode'] as String?,
      hidden: json['hidden'] as bool?,
      options: (json['options'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      color: json['color'],
      steps: (json['steps'] as num?)?.toInt(),
      maxSteps: (json['maxSteps'] as num?)?.toInt(),
      permission: json['permission'],
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'model': model,
    'variant': variant,
    'temperature': temperature,
    'top_p': top_p,
    'prompt': prompt,
    'tools': tools,
    'disable': disable,
    'description': description,
    'mode': mode,
    'hidden': hidden,
    'options': options,
    'color': color,
    'steps': steps,
    'maxSteps': maxSteps,
    'permission': permission,
  };
}

class ProviderConfig {
  /// Создаёт модель из полей.
  ProviderConfig({
    this.api,
    this.name,
    this.env,
    this.id,
    this.npm,
    this.whitelist,
    this.blacklist,
    this.options,
    this.models,
  });
  final String? api;
  final String? name;
  final List<String>? env;
  final String? id;
  final String? npm;
  final List<String>? whitelist;
  final List<String>? blacklist;
  final Map<String, dynamic>? options;
  final Map<String, Map<String, dynamic>>? models;

  /// Разбирает JSON в [Object] типа ProviderConfig.
  factory ProviderConfig.fromJson(Map<String, Object?> json) {
    return ProviderConfig(
      api: json['api'] as String?,
      name: json['name'] as String?,
      env: (json['env'] as List?)?.map((e) => e as String).toList(),
      id: json['id'] as String?,
      npm: json['npm'] as String?,
      whitelist: (json['whitelist'] as List?)?.map((e) => e as String).toList(),
      blacklist: (json['blacklist'] as List?)?.map((e) => e as String).toList(),
      options: (json['options'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      models: (json['models'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v as Map<String, Object?>),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'api': api,
    'name': name,
    'env': env,
    'id': id,
    'npm': npm,
    'whitelist': whitelist,
    'blacklist': blacklist,
    'options': options,
    'models': models,
  };
}

class McpLocalConfig {
  /// Создаёт модель из полей.
  McpLocalConfig({
    required this.type,
    required this.command,
    this.cwd,
    this.environment,
    this.enabled,
    this.timeout,
  });
  final String type;
  final List<String> command;
  final String? cwd;
  final Map<String, String>? environment;
  final bool? enabled;
  final int? timeout;

  /// Разбирает JSON в [Object] типа McpLocalConfig.
  factory McpLocalConfig.fromJson(Map<String, Object?> json) {
    return McpLocalConfig(
      type: json['type'] as String,
      command: (json['command'] as List).map((e) => e as String).toList(),
      cwd: json['cwd'] as String?,
      environment: (json['environment'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v as String),
      ),
      enabled: json['enabled'] as bool?,
      timeout: (json['timeout'] as num?)?.toInt(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'command': command,
    'cwd': cwd,
    'environment': environment,
    'enabled': enabled,
    'timeout': timeout,
  };
}

class McpOAuthConfig {
  /// Создаёт модель из полей.
  McpOAuthConfig({
    this.clientId,
    this.clientSecret,
    this.scope,
    this.callbackPort,
    this.redirectUri,
  });
  final String? clientId;
  final String? clientSecret;
  final String? scope;
  final int? callbackPort;
  final String? redirectUri;

  /// Разбирает JSON в [Object] типа McpOAuthConfig.
  factory McpOAuthConfig.fromJson(Map<String, Object?> json) {
    return McpOAuthConfig(
      clientId: json['clientId'] as String?,
      clientSecret: json['clientSecret'] as String?,
      scope: json['scope'] as String?,
      callbackPort: (json['callbackPort'] as num?)?.toInt(),
      redirectUri: json['redirectUri'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'clientId': clientId,
    'clientSecret': clientSecret,
    'scope': scope,
    'callbackPort': callbackPort,
    'redirectUri': redirectUri,
  };
}

class McpRemoteConfig {
  /// Создаёт модель из полей.
  McpRemoteConfig({
    required this.type,
    required this.url,
    this.enabled,
    this.headers,
    this.oauth,
    this.timeout,
  });
  final String type;
  final String url;
  final bool? enabled;
  final Map<String, String>? headers;
  final dynamic oauth;
  final int? timeout;

  /// Разбирает JSON в [Object] типа McpRemoteConfig.
  factory McpRemoteConfig.fromJson(Map<String, Object?> json) {
    return McpRemoteConfig(
      type: json['type'] as String,
      url: json['url'] as String,
      enabled: json['enabled'] as bool?,
      headers: (json['headers'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v as String),
      ),
      oauth: json['oauth'],
      timeout: (json['timeout'] as num?)?.toInt(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'url': url,
    'enabled': enabled,
    'headers': headers,
    'oauth': oauth,
    'timeout': timeout,
  };
}

class ImageAttachmentConfig {
  /// Создаёт модель из полей.
  ImageAttachmentConfig({
    this.auto_resize,
    this.max_width,
    this.max_height,
    this.max_base64_bytes,
  });
  final bool? auto_resize;
  final int? max_width;
  final int? max_height;
  final int? max_base64_bytes;

  /// Разбирает JSON в [Object] типа ImageAttachmentConfig.
  factory ImageAttachmentConfig.fromJson(Map<String, Object?> json) {
    return ImageAttachmentConfig(
      auto_resize: json['auto_resize'] as bool?,
      max_width: (json['max_width'] as num?)?.toInt(),
      max_height: (json['max_height'] as num?)?.toInt(),
      max_base64_bytes: (json['max_base64_bytes'] as num?)?.toInt(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'auto_resize': auto_resize,
    'max_width': max_width,
    'max_height': max_height,
    'max_base64_bytes': max_base64_bytes,
  };
}

class AttachmentConfig {
  /// Создаёт модель из полей.
  AttachmentConfig({this.image});
  final ImageAttachmentConfig? image;

  /// Разбирает JSON в [Object] типа AttachmentConfig.
  factory AttachmentConfig.fromJson(Map<String, Object?> json) {
    return AttachmentConfig(
      image: (json['image'] as Map<String, Object?>?) == null
          ? null
          : ImageAttachmentConfig.fromJson(
              json['image'] as Map<String, Object?>,
            ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'image': image?.toJson()};
}

class Config {
  /// Создаёт модель из полей.
  Config({
    this.schema,
    this.shell,
    this.logLevel,
    this.server,
    this.command,
    this.skills,
    this.references,
    this.reference,
    this.watcher,
    this.snapshot,
    this.plugin,
    this.share,
    this.autoshare,
    this.autoupdate,
    this.disabled_providers,
    this.enabled_providers,
    this.model,
    this.small_model,
    this.default_agent,
    this.subagent_depth,
    this.username,
    this.mode,
    this.agent,
    this.provider,
    this.mcp,
    this.formatter,
    this.lsp,
    this.instructions,
    this.layout,
    this.permission,
    this.tools,
    this.attachment,
    this.enterprise,
    this.tool_output,
    this.compaction,
    this.experimental,
  });
  final String? schema;
  final String? shell;
  final String? logLevel;
  final ServerConfig? server;
  final Map<String, Map<String, dynamic>>? command;
  final Map<String, dynamic>? skills;
  final Map<String, dynamic>? references;
  final Map<String, dynamic>? reference;
  final Map<String, dynamic>? watcher;
  final bool? snapshot;
  final List<dynamic>? plugin;
  final String? share;
  final bool? autoshare;
  final dynamic autoupdate;
  final List<String>? disabled_providers;
  final List<String>? enabled_providers;
  final String? model;
  final String? small_model;
  final String? default_agent;
  final int? subagent_depth;
  final String? username;
  final Map<String, AgentConfig>? mode;
  final Map<String, AgentConfig>? agent;
  final Map<String, ProviderConfig>? provider;
  final Map<String, dynamic>? mcp;
  final dynamic formatter;
  final dynamic lsp;
  final List<String>? instructions;
  final String? layout;
  final dynamic permission;
  final Map<String, bool>? tools;
  final AttachmentConfig? attachment;
  final Map<String, dynamic>? enterprise;
  final Map<String, dynamic>? tool_output;
  final Map<String, dynamic>? compaction;
  final Map<String, dynamic>? experimental;

  /// Разбирает JSON в [Object] типа Config.
  factory Config.fromJson(Map<String, Object?> json) {
    return Config(
      schema: json['\$schema'] as String?,
      shell: json['shell'] as String?,
      logLevel: json['logLevel'] as String?,
      server: (json['server'] as Map<String, Object?>?) == null
          ? null
          : ServerConfig.fromJson(json['server'] as Map<String, Object?>),
      command: (json['command'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v as Map<String, Object?>),
      ),
      skills: (json['skills'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      references: (json['references'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      reference: (json['reference'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      watcher: (json['watcher'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      snapshot: json['snapshot'] as bool?,
      plugin: (json['plugin'] as List?)?.cast<dynamic>(),
      share: json['share'] as String?,
      autoshare: json['autoshare'] as bool?,
      autoupdate: json['autoupdate'],
      disabled_providers: (json['disabled_providers'] as List?)
          ?.map((e) => e as String)
          .toList(),
      enabled_providers: (json['enabled_providers'] as List?)
          ?.map((e) => e as String)
          .toList(),
      model: json['model'] as String?,
      small_model: json['small_model'] as String?,
      default_agent: json['default_agent'] as String?,
      subagent_depth: (json['subagent_depth'] as num?)?.toInt(),
      username: json['username'] as String?,
      mode: (json['mode'] as Map?)?.map(
        (k, v) => MapEntry(
          k as String,
          AgentConfig.fromJson(v as Map<String, Object?>),
        ),
      ),
      agent: (json['agent'] as Map?)?.map(
        (k, v) => MapEntry(
          k as String,
          AgentConfig.fromJson(v as Map<String, Object?>),
        ),
      ),
      provider: (json['provider'] as Map?)?.map(
        (k, v) => MapEntry(
          k as String,
          ProviderConfig.fromJson(v as Map<String, Object?>),
        ),
      ),
      mcp: (json['mcp'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      formatter: json['formatter'],
      lsp: json['lsp'],
      instructions: (json['instructions'] as List?)
          ?.map((e) => e as String)
          .toList(),
      layout: json['layout'] as String?,
      permission: json['permission'],
      tools: (json['tools'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v as bool),
      ),
      attachment: (json['attachment'] as Map<String, Object?>?) == null
          ? null
          : AttachmentConfig.fromJson(
              json['attachment'] as Map<String, Object?>,
            ),
      enterprise: (json['enterprise'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      tool_output: (json['tool_output'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      compaction: (json['compaction'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      experimental: (json['experimental'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    '\$schema': schema,
    'shell': shell,
    'logLevel': logLevel,
    'server': server?.toJson(),
    'command': command,
    'skills': skills,
    'references': references,
    'reference': reference,
    'watcher': watcher,
    'snapshot': snapshot,
    'plugin': plugin,
    'share': share,
    'autoshare': autoshare,
    'autoupdate': autoupdate,
    'disabled_providers': disabled_providers,
    'enabled_providers': enabled_providers,
    'model': model,
    'small_model': small_model,
    'default_agent': default_agent,
    'subagent_depth': subagent_depth,
    'username': username,
    'mode': mode,
    'agent': agent,
    'provider': provider,
    'mcp': mcp,
    'formatter': formatter,
    'lsp': lsp,
    'instructions': instructions,
    'layout': layout,
    'permission': permission,
    'tools': tools,
    'attachment': attachment?.toJson(),
    'enterprise': enterprise,
    'tool_output': tool_output,
    'compaction': compaction,
    'experimental': experimental,
  };
}

class Model {
  /// Создаёт модель из полей.
  Model({
    required this.id,
    required this.providerID,
    required this.api,
    required this.name,
    this.family,
    required this.capabilities,
    required this.cost,
    required this.limit,
    required this.status,
    required this.options,
    required this.headers,
    required this.release_date,
    this.variants,
  });
  final String id;
  final String providerID;
  final Map<String, dynamic> api;
  final String name;
  final String? family;
  final Map<String, dynamic> capabilities;
  final Map<String, dynamic> cost;
  final Map<String, dynamic> limit;
  final String status;
  final Map<String, dynamic> options;
  final Map<String, String> headers;
  final String release_date;
  final Map<String, Map<String, dynamic>>? variants;

  /// Разбирает JSON в [Object] типа Model.
  factory Model.fromJson(Map<String, Object?> json) {
    return Model(
      id: json['id'] as String,
      providerID: json['providerID'] as String,
      api: (json['api'] as Map).map((k, v) => MapEntry(k as String, v)),
      name: json['name'] as String,
      family: json['family'] as String?,
      capabilities: (json['capabilities'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
      cost: (json['cost'] as Map).map((k, v) => MapEntry(k as String, v)),
      limit: (json['limit'] as Map).map((k, v) => MapEntry(k as String, v)),
      status: json['status'] as String,
      options: (json['options'] as Map).map((k, v) => MapEntry(k as String, v)),
      headers: (json['headers'] as Map).map(
        (k, v) => MapEntry(k as String, v as String),
      ),
      release_date: json['release_date'] as String,
      variants: (json['variants'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v as Map<String, Object?>),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'providerID': providerID,
    'api': api,
    'name': name,
    'family': family,
    'capabilities': capabilities,
    'cost': cost,
    'limit': limit,
    'status': status,
    'options': options,
    'headers': headers,
    'release_date': release_date,
    'variants': variants,
  };
}

class Provider {
  /// Создаёт модель из полей.
  Provider({
    required this.id,
    required this.name,
    required this.source,
    required this.env,
    this.key,
    required this.options,
    required this.models,
  });
  final String id;
  final String name;
  final String source;
  final List<String> env;
  final String? key;
  final Map<String, dynamic> options;
  final Map<String, Model> models;

  /// Разбирает JSON в [Object] типа Provider.
  factory Provider.fromJson(Map<String, Object?> json) {
    return Provider(
      id: json['id'] as String,
      name: json['name'] as String,
      source: json['source'] as String,
      env: (json['env'] as List).map((e) => e as String).toList(),
      key: json['key'] as String?,
      options: (json['options'] as Map).map((k, v) => MapEntry(k as String, v)),
      models: (json['models'] as Map).map(
        (k, v) =>
            MapEntry(k as String, Model.fromJson(v as Map<String, Object?>)),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'source': source,
    'env': env,
    'key': key,
    'options': options,
    'models': models,
  };
}

class ExperimentalCapabilities {
  /// Создаёт модель из полей.
  ExperimentalCapabilities({required this.backgroundSubagents});
  final bool backgroundSubagents;

  /// Разбирает JSON в [Object] типа ExperimentalCapabilities.
  factory ExperimentalCapabilities.fromJson(Map<String, Object?> json) {
    return ExperimentalCapabilities(
      backgroundSubagents: json['backgroundSubagents'] as bool,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'backgroundSubagents': backgroundSubagents};
}

class ConsoleState {
  /// Создаёт модель из полей.
  ConsoleState({
    required this.consoleManagedProviders,
    this.activeOrgName,
    required this.switchableOrgCount,
  });
  final List<String> consoleManagedProviders;
  final String? activeOrgName;
  final int switchableOrgCount;

  /// Разбирает JSON в [Object] типа ConsoleState.
  factory ConsoleState.fromJson(Map<String, Object?> json) {
    return ConsoleState(
      consoleManagedProviders: (json['consoleManagedProviders'] as List)
          .map((e) => e as String)
          .toList(),
      activeOrgName: json['activeOrgName'] as String?,
      switchableOrgCount: (json['switchableOrgCount'] as num).toInt(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'consoleManagedProviders': consoleManagedProviders,
    'activeOrgName': activeOrgName,
    'switchableOrgCount': switchableOrgCount,
  };
}

class EffectHttpApiErrorInternalServerError {
  /// Создаёт модель из полей.
  EffectHttpApiErrorInternalServerError({required this.tag});
  final String tag;

  /// Разбирает JSON в [Object] типа EffectHttpApiErrorInternalServerError.
  factory EffectHttpApiErrorInternalServerError.fromJson(
    Map<String, Object?> json,
  ) {
    return EffectHttpApiErrorInternalServerError(tag: json['_tag'] as String);
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'_tag': tag};
}

class ToolListItem {
  /// Создаёт модель из полей.
  ToolListItem({
    required this.id,
    required this.description,
    required this.parameters,
  });
  final String id;
  final String description;
  final dynamic parameters;

  /// Разбирает JSON в [Object] типа ToolListItem.
  factory ToolListItem.fromJson(Map<String, Object?> json) {
    return ToolListItem(
      id: json['id'] as String,
      description: json['description'] as String,
      parameters: json['parameters'],
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'description': description,
    'parameters': parameters,
  };
}

class WorktreeError {
  /// Создаёт модель из полей.
  WorktreeError({required this.name, required this.data});
  final String name;
  final Map<String, dynamic> data;

  /// Разбирает JSON в [Object] типа WorktreeError.
  factory WorktreeError.fromJson(Map<String, Object?> json) {
    return WorktreeError(
      name: json['name'] as String,
      data: (json['data'] as Map).map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'name': name, 'data': data};
}

class WorktreeCreateInput {
  /// Создаёт модель из полей.
  WorktreeCreateInput({this.name, this.startCommand});
  final String? name;
  final String? startCommand;

  /// Разбирает JSON в [Object] типа WorktreeCreateInput.
  factory WorktreeCreateInput.fromJson(Map<String, Object?> json) {
    return WorktreeCreateInput(
      name: json['name'] as String?,
      startCommand: json['startCommand'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'name': name, 'startCommand': startCommand};
}

class Worktree {
  /// Создаёт модель из полей.
  Worktree({required this.name, this.branch, required this.directory});
  final String name;
  final String? branch;
  final String directory;

  /// Разбирает JSON в [Object] типа Worktree.
  factory Worktree.fromJson(Map<String, Object?> json) {
    return Worktree(
      name: json['name'] as String,
      branch: json['branch'] as String?,
      directory: json['directory'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'name': name,
    'branch': branch,
    'directory': directory,
  };
}

class WorktreeRemoveInput {
  /// Создаёт модель из полей.
  WorktreeRemoveInput({required this.directory});
  final String directory;

  /// Разбирает JSON в [Object] типа WorktreeRemoveInput.
  factory WorktreeRemoveInput.fromJson(Map<String, Object?> json) {
    return WorktreeRemoveInput(directory: json['directory'] as String);
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'directory': directory};
}

class WorktreeResetInput {
  /// Создаёт модель из полей.
  WorktreeResetInput({required this.directory});
  final String directory;

  /// Разбирает JSON в [Object] типа WorktreeResetInput.
  factory WorktreeResetInput.fromJson(Map<String, Object?> json) {
    return WorktreeResetInput(directory: json['directory'] as String);
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'directory': directory};
}

class ProjectSummary {
  /// Создаёт модель из полей.
  ProjectSummary({required this.id, this.name, required this.worktree});
  final String id;
  final String? name;
  final String worktree;

  /// Разбирает JSON в [Object] типа ProjectSummary.
  factory ProjectSummary.fromJson(Map<String, Object?> json) {
    return ProjectSummary(
      id: json['id'] as String,
      name: json['name'] as String?,
      worktree: json['worktree'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'worktree': worktree,
  };
}

class GlobalSession {
  /// Создаёт модель из полей.
  GlobalSession({
    required this.id,
    required this.slug,
    required this.projectID,
    this.workspaceID,
    required this.directory,
    this.path,
    this.parentID,
    this.summary,
    this.cost,
    this.tokens,
    this.share,
    required this.title,
    this.agent,
    this.model,
    required this.version,
    this.metadata,
    required this.time,
    this.permission,
    this.revert,
    required this.project,
  });
  final String id;
  final String slug;
  final String projectID;
  final String? workspaceID;
  final String directory;
  final String? path;
  final String? parentID;
  final Map<String, dynamic>? summary;
  final double? cost;
  final Map<String, dynamic>? tokens;
  final Map<String, dynamic>? share;
  final String title;
  final String? agent;
  final Map<String, dynamic>? model;
  final String version;
  final Map<String, dynamic>? metadata;
  final Map<String, dynamic> time;
  final PermissionRule? permission;
  final Map<String, dynamic>? revert;
  final dynamic project;

  /// Разбирает JSON в [Object] типа GlobalSession.
  factory GlobalSession.fromJson(Map<String, Object?> json) {
    return GlobalSession(
      id: json['id'] as String,
      slug: json['slug'] as String,
      projectID: json['projectID'] as String,
      workspaceID: json['workspaceID'] as String?,
      directory: json['directory'] as String,
      path: json['path'] as String?,
      parentID: json['parentID'] as String?,
      summary: (json['summary'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      cost: (json['cost'] as num?)?.toDouble(),
      tokens: (json['tokens'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      share: (json['share'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      title: json['title'] as String,
      agent: json['agent'] as String?,
      model: (json['model'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      version: json['version'] as String,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      time: (json['time'] as Map).map((k, v) => MapEntry(k as String, v)),
      permission: (json['permission'] as Map<String, Object?>?) == null
          ? null
          : PermissionRule.fromJson(json['permission'] as Map<String, Object?>),
      revert: (json['revert'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      project: json['project'],
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'slug': slug,
    'projectID': projectID,
    'workspaceID': workspaceID,
    'directory': directory,
    'path': path,
    'parentID': parentID,
    'summary': summary,
    'cost': cost,
    'tokens': tokens,
    'share': share,
    'title': title,
    'agent': agent,
    'model': model,
    'version': version,
    'metadata': metadata,
    'time': time,
    'permission': permission?.toJson(),
    'revert': revert,
    'project': project,
  };
}

class McpResource {
  /// Создаёт модель из полей.
  McpResource({
    required this.name,
    required this.uri,
    this.description,
    this.mimeType,
    required this.client,
  });
  final String name;
  final String uri;
  final String? description;
  final String? mimeType;
  final String client;

  /// Разбирает JSON в [Object] типа McpResource.
  factory McpResource.fromJson(Map<String, Object?> json) {
    return McpResource(
      name: json['name'] as String,
      uri: json['uri'] as String,
      description: json['description'] as String?,
      mimeType: json['mimeType'] as String?,
      client: json['client'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'name': name,
    'uri': uri,
    'description': description,
    'mimeType': mimeType,
    'client': client,
  };
}

class Symbol {
  /// Создаёт модель из полей.
  Symbol({required this.name, required this.kind, required this.location});
  final String name;
  final int kind;
  final Map<String, dynamic> location;

  /// Разбирает JSON в [Object] типа Symbol.
  factory Symbol.fromJson(Map<String, Object?> json) {
    return Symbol(
      name: json['name'] as String,
      kind: (json['kind'] as num).toInt(),
      location: (json['location'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'name': name,
    'kind': kind,
    'location': location,
  };
}

class FileNode {
  /// Создаёт модель из полей.
  FileNode({
    required this.name,
    required this.path,
    required this.absolute,
    required this.type,
    required this.ignored,
  });
  final String name;
  final String path;
  final String absolute;
  final String type;
  final bool ignored;

  /// Разбирает JSON в [Object] типа FileNode.
  factory FileNode.fromJson(Map<String, Object?> json) {
    return FileNode(
      name: json['name'] as String,
      path: json['path'] as String,
      absolute: json['absolute'] as String,
      type: json['type'] as String,
      ignored: json['ignored'] as bool,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'name': name,
    'path': path,
    'absolute': absolute,
    'type': type,
    'ignored': ignored,
  };
}

class FileContent {
  /// Создаёт модель из полей.
  FileContent({
    required this.type,
    required this.content,
    this.diff,
    this.patch,
    this.encoding,
    this.mimeType,
  });
  final String type;
  final String content;
  final String? diff;
  final Map<String, dynamic>? patch;
  final String? encoding;
  final String? mimeType;

  /// Разбирает JSON в [Object] типа FileContent.
  factory FileContent.fromJson(Map<String, Object?> json) {
    return FileContent(
      type: json['type'] as String,
      content: json['content'] as String,
      diff: json['diff'] as String?,
      patch: (json['patch'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      encoding: json['encoding'] as String?,
      mimeType: json['mimeType'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'content': content,
    'diff': diff,
    'patch': patch,
    'encoding': encoding,
    'mimeType': mimeType,
  };
}

class File {
  /// Создаёт модель из полей.
  File({
    required this.path,
    required this.added,
    required this.removed,
    required this.status,
  });
  final String path;
  final int added;
  final int removed;
  final String status;

  /// Разбирает JSON в [Object] типа File.
  factory File.fromJson(Map<String, Object?> json) {
    return File(
      path: json['path'] as String,
      added: (json['added'] as num).toInt(),
      removed: (json['removed'] as num).toInt(),
      status: json['status'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'path': path,
    'added': added,
    'removed': removed,
    'status': status,
  };
}

class Path {
  /// Создаёт модель из полей.
  Path({
    required this.home,
    required this.state,
    required this.config,
    required this.worktree,
    required this.directory,
  });
  final String home;
  final String state;
  final String config;
  final String worktree;
  final String directory;

  /// Разбирает JSON в [Object] типа Path.
  factory Path.fromJson(Map<String, Object?> json) {
    return Path(
      home: json['home'] as String,
      state: json['state'] as String,
      config: json['config'] as String,
      worktree: json['worktree'] as String,
      directory: json['directory'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'home': home,
    'state': state,
    'config': config,
    'worktree': worktree,
    'directory': directory,
  };
}

class VcsInfo {
  /// Создаёт модель из полей.
  VcsInfo({this.branch, this.default_branch});
  final String? branch;
  final String? default_branch;

  /// Разбирает JSON в [Object] типа VcsInfo.
  factory VcsInfo.fromJson(Map<String, Object?> json) {
    return VcsInfo(
      branch: json['branch'] as String?,
      default_branch: json['default_branch'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'branch': branch,
    'default_branch': default_branch,
  };
}

class VcsFileStatus {
  /// Создаёт модель из полей.
  VcsFileStatus({
    required this.file,
    required this.additions,
    required this.deletions,
    required this.status,
  });
  final String file;
  final double additions;
  final double deletions;
  final String status;

  /// Разбирает JSON в [Object] типа VcsFileStatus.
  factory VcsFileStatus.fromJson(Map<String, Object?> json) {
    return VcsFileStatus(
      file: json['file'] as String,
      additions: (json['additions'] as num).toDouble(),
      deletions: (json['deletions'] as num).toDouble(),
      status: json['status'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'file': file,
    'additions': additions,
    'deletions': deletions,
    'status': status,
  };
}

class VcsFileDiff {
  /// Создаёт модель из полей.
  VcsFileDiff({
    required this.file,
    this.patch,
    required this.additions,
    required this.deletions,
    this.status,
  });
  final String file;
  final String? patch;
  final double additions;
  final double deletions;
  final String? status;

  /// Разбирает JSON в [Object] типа VcsFileDiff.
  factory VcsFileDiff.fromJson(Map<String, Object?> json) {
    return VcsFileDiff(
      file: json['file'] as String,
      patch: json['patch'] as String?,
      additions: (json['additions'] as num).toDouble(),
      deletions: (json['deletions'] as num).toDouble(),
      status: json['status'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'file': file,
    'patch': patch,
    'additions': additions,
    'deletions': deletions,
    'status': status,
  };
}

class VcsApplyError {
  /// Создаёт модель из полей.
  VcsApplyError({required this.name, required this.data});
  final String name;
  final Map<String, dynamic> data;

  /// Разбирает JSON в [Object] типа VcsApplyError.
  factory VcsApplyError.fromJson(Map<String, Object?> json) {
    return VcsApplyError(
      name: json['name'] as String,
      data: (json['data'] as Map).map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'name': name, 'data': data};
}

class Command {
  /// Создаёт модель из полей.
  Command({
    required this.name,
    this.description,
    this.agent,
    this.model,
    this.source,
    required this.template,
    this.subtask,
    required this.hints,
  });
  final String name;
  final String? description;
  final String? agent;
  final String? model;
  final String? source;
  final String template;
  final bool? subtask;
  final List<String> hints;

  /// Разбирает JSON в [Object] типа Command.
  factory Command.fromJson(Map<String, Object?> json) {
    return Command(
      name: json['name'] as String,
      description: json['description'] as String?,
      agent: json['agent'] as String?,
      model: json['model'] as String?,
      source: json['source'] as String?,
      template: json['template'] as String,
      subtask: json['subtask'] as bool?,
      hints: (json['hints'] as List).map((e) => e as String).toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'name': name,
    'description': description,
    'agent': agent,
    'model': model,
    'source': source,
    'template': template,
    'subtask': subtask,
    'hints': hints,
  };
}

class Agent {
  /// Создаёт модель из полей.
  Agent({
    required this.name,
    this.description,
    required this.mode,
    this.native,
    this.hidden,
    this.topP,
    this.temperature,
    this.color,
    required this.permission,
    this.model,
    this.variant,
    this.prompt,
    required this.options,
    this.steps,
  });
  final String name;
  final String? description;
  final String mode;
  final bool? native;
  final bool? hidden;
  final double? topP;
  final double? temperature;
  final String? color;
  final PermissionRule permission;
  final Map<String, dynamic>? model;
  final String? variant;
  final String? prompt;
  final Map<String, dynamic> options;
  final double? steps;

  /// Разбирает JSON в [Object] типа Agent.
  factory Agent.fromJson(Map<String, Object?> json) {
    return Agent(
      name: json['name'] as String,
      description: json['description'] as String?,
      mode: json['mode'] as String,
      native: json['native'] as bool?,
      hidden: json['hidden'] as bool?,
      topP: (json['topP'] as num?)?.toDouble(),
      temperature: (json['temperature'] as num?)?.toDouble(),
      color: json['color'] as String?,
      permission: PermissionRule.fromJson(
        json['permission'] as Map<String, Object?>,
      ),
      model: (json['model'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      variant: json['variant'] as String?,
      prompt: json['prompt'] as String?,
      options: (json['options'] as Map).map((k, v) => MapEntry(k as String, v)),
      steps: (json['steps'] as num?)?.toDouble(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'name': name,
    'description': description,
    'mode': mode,
    'native': native,
    'hidden': hidden,
    'topP': topP,
    'temperature': temperature,
    'color': color,
    'permission': permission?.toJson(),
    'model': model,
    'variant': variant,
    'prompt': prompt,
    'options': options,
    'steps': steps,
  };
}

class LSPStatus {
  /// Создаёт модель из полей.
  LSPStatus({
    required this.id,
    required this.name,
    required this.root,
    required this.status,
  });
  final String id;
  final String name;
  final String root;
  final String status;

  /// Разбирает JSON в [Object] типа LSPStatus.
  factory LSPStatus.fromJson(Map<String, Object?> json) {
    return LSPStatus(
      id: json['id'] as String,
      name: json['name'] as String,
      root: json['root'] as String,
      status: json['status'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'root': root,
    'status': status,
  };
}

class FormatterStatus {
  /// Создаёт модель из полей.
  FormatterStatus({
    required this.name,
    required this.extensions,
    required this.enabled,
  });
  final String name;
  final List<String> extensions;
  final bool enabled;

  /// Разбирает JSON в [Object] типа FormatterStatus.
  factory FormatterStatus.fromJson(Map<String, Object?> json) {
    return FormatterStatus(
      name: json['name'] as String,
      extensions: (json['extensions'] as List).map((e) => e as String).toList(),
      enabled: json['enabled'] as bool,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'name': name,
    'extensions': extensions,
    'enabled': enabled,
  };
}

class MCPStatusConnected {
  /// Создаёт модель из полей.
  MCPStatusConnected({this.status});
  final String? status;

  /// Разбирает JSON в [Object] типа MCPStatusConnected.
  factory MCPStatusConnected.fromJson(Map<String, Object?> json) {
    return MCPStatusConnected(status: json['status'] as String?);
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'status': status};
}

class MCPStatusDisabled {
  /// Создаёт модель из полей.
  MCPStatusDisabled({this.status});
  final String? status;

  /// Разбирает JSON в [Object] типа MCPStatusDisabled.
  factory MCPStatusDisabled.fromJson(Map<String, Object?> json) {
    return MCPStatusDisabled(status: json['status'] as String?);
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'status': status};
}

class MCPStatusFailed {
  /// Создаёт модель из полей.
  MCPStatusFailed({this.status, this.error});
  final String? status;
  final String? error;

  /// Разбирает JSON в [Object] типа MCPStatusFailed.
  factory MCPStatusFailed.fromJson(Map<String, Object?> json) {
    return MCPStatusFailed(
      status: json['status'] as String?,
      error: json['error'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'status': status, 'error': error};
}

class MCPStatusNeedsAuth {
  /// Создаёт модель из полей.
  MCPStatusNeedsAuth({this.status});
  final String? status;

  /// Разбирает JSON в [Object] типа MCPStatusNeedsAuth.
  factory MCPStatusNeedsAuth.fromJson(Map<String, Object?> json) {
    return MCPStatusNeedsAuth(status: json['status'] as String?);
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'status': status};
}

class MCPStatusNeedsClientRegistration {
  /// Создаёт модель из полей.
  MCPStatusNeedsClientRegistration({this.status, this.error});
  final String? status;
  final String? error;

  /// Разбирает JSON в [Object] типа MCPStatusNeedsClientRegistration.
  factory MCPStatusNeedsClientRegistration.fromJson(Map<String, Object?> json) {
    return MCPStatusNeedsClientRegistration(
      status: json['status'] as String?,
      error: json['error'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'status': status, 'error': error};
}

class McpUnsupportedOAuthError {
  /// Создаёт модель из полей.
  McpUnsupportedOAuthError({required this.error});
  final String error;

  /// Разбирает JSON в [Object] типа McpUnsupportedOAuthError.
  factory McpUnsupportedOAuthError.fromJson(Map<String, Object?> json) {
    return McpUnsupportedOAuthError(error: json['error'] as String);
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'error': error};
}

class McpServerNotFoundError {
  /// Создаёт модель из полей.
  McpServerNotFoundError({
    required this.tag,
    required this.name,
    required this.message,
  });
  final String tag;
  final String name;
  final String message;

  /// Разбирает JSON в [Object] типа McpServerNotFoundError.
  factory McpServerNotFoundError.fromJson(Map<String, Object?> json) {
    return McpServerNotFoundError(
      tag: json['_tag'] as String,
      name: json['name'] as String,
      message: json['message'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    '_tag': tag,
    'name': name,
    'message': message,
  };
}

class ProjectIcon {
  /// Создаёт модель из полей.
  ProjectIcon({this.url, this.override, this.color});
  final String? url;
  final String? override;
  final String? color;

  /// Разбирает JSON в [Object] типа ProjectIcon.
  factory ProjectIcon.fromJson(Map<String, Object?> json) {
    return ProjectIcon(
      url: json['url'] as String?,
      override: json['override'] as String?,
      color: json['color'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'url': url,
    'override': override,
    'color': color,
  };
}

class ProjectCommands {
  /// Создаёт модель из полей.
  ProjectCommands({this.start});
  final String? start;

  /// Разбирает JSON в [Object] типа ProjectCommands.
  factory ProjectCommands.fromJson(Map<String, Object?> json) {
    return ProjectCommands(start: json['start'] as String?);
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'start': start};
}

class ProjectTime {
  /// Создаёт модель из полей.
  ProjectTime({required this.created, required this.updated, this.initialized});
  final int created;
  final int updated;
  final int? initialized;

  /// Разбирает JSON в [Object] типа ProjectTime.
  factory ProjectTime.fromJson(Map<String, Object?> json) {
    return ProjectTime(
      created: (json['created'] as num).toInt(),
      updated: (json['updated'] as num).toInt(),
      initialized: (json['initialized'] as num?)?.toInt(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'created': created,
    'updated': updated,
    'initialized': initialized,
  };
}

class Project {
  /// Создаёт модель из полей.
  Project({
    required this.id,
    required this.worktree,
    this.vcs,
    this.name,
    this.icon,
    this.commands,
    required this.time,
    required this.sandboxes,
  });
  final String id;
  final String worktree;
  final String? vcs;
  final String? name;
  final ProjectIcon? icon;
  final ProjectCommands? commands;
  final ProjectTime time;
  final List<String> sandboxes;

  /// Разбирает JSON в [Object] типа Project.
  factory Project.fromJson(Map<String, Object?> json) {
    return Project(
      id: json['id'] as String,
      worktree: json['worktree'] as String,
      vcs: json['vcs'] as String?,
      name: json['name'] as String?,
      icon: (json['icon'] as Map<String, Object?>?) == null
          ? null
          : ProjectIcon.fromJson(json['icon'] as Map<String, Object?>),
      commands: (json['commands'] as Map<String, Object?>?) == null
          ? null
          : ProjectCommands.fromJson(json['commands'] as Map<String, Object?>),
      time: ProjectTime.fromJson(json['time'] as Map<String, Object?>),
      sandboxes: (json['sandboxes'] as List).map((e) => e as String).toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'worktree': worktree,
    'vcs': vcs,
    'name': name,
    'icon': icon?.toJson(),
    'commands': commands?.toJson(),
    'time': time?.toJson(),
    'sandboxes': sandboxes,
  };
}

class ProjectNotFoundError {
  /// Создаёт модель из полей.
  ProjectNotFoundError({
    required this.tag,
    required this.projectID,
    required this.message,
  });
  final String tag;
  final String projectID;
  final String message;

  /// Разбирает JSON в [Object] типа ProjectNotFoundError.
  factory ProjectNotFoundError.fromJson(Map<String, Object?> json) {
    return ProjectNotFoundError(
      tag: json['_tag'] as String,
      projectID: json['projectID'] as String,
      message: json['message'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    '_tag': tag,
    'projectID': projectID,
    'message': message,
  };
}

class PtyNotFoundError {
  /// Создаёт модель из полей.
  PtyNotFoundError({
    required this.tag,
    required this.ptyID,
    required this.message,
  });
  final String tag;
  final String ptyID;
  final String message;

  /// Разбирает JSON в [Object] типа PtyNotFoundError.
  factory PtyNotFoundError.fromJson(Map<String, Object?> json) {
    return PtyNotFoundError(
      tag: json['_tag'] as String,
      ptyID: json['ptyID'] as String,
      message: json['message'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    '_tag': tag,
    'ptyID': ptyID,
    'message': message,
  };
}

class PtyForbiddenError {
  /// Создаёт модель из полей.
  PtyForbiddenError({required this.tag, required this.message});
  final String tag;
  final String message;

  /// Разбирает JSON в [Object] типа PtyForbiddenError.
  factory PtyForbiddenError.fromJson(Map<String, Object?> json) {
    return PtyForbiddenError(
      tag: json['_tag'] as String,
      message: json['message'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'_tag': tag, 'message': message};
}

class QuestionRequest {
  /// Создаёт модель из полей.
  QuestionRequest({
    required this.id,
    required this.sessionID,
    required this.questions,
    this.tool,
  });
  final String id;
  final String sessionID;
  final List<QuestionInfo> questions;
  final QuestionTool? tool;

  /// Разбирает JSON в [Object] типа QuestionRequest.
  factory QuestionRequest.fromJson(Map<String, Object?> json) {
    return QuestionRequest(
      id: json['id'] as String,
      sessionID: json['sessionID'] as String,
      questions: (json['questions'] as List)
          .map((e) => QuestionInfo.fromJson(e as Map<String, Object?>))
          .toList(),
      tool: (json['tool'] as Map<String, Object?>?) == null
          ? null
          : QuestionTool.fromJson(json['tool'] as Map<String, Object?>),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'sessionID': sessionID,
    'questions': questions?.map((e) => e.toJson()).toList(),
    'tool': tool?.toJson(),
  };
}

class QuestionNotFoundError {
  /// Создаёт модель из полей.
  QuestionNotFoundError({
    required this.tag,
    required this.requestID,
    required this.message,
  });
  final String tag;
  final String requestID;
  final String message;

  /// Разбирает JSON в [Object] типа QuestionNotFoundError.
  factory QuestionNotFoundError.fromJson(Map<String, Object?> json) {
    return QuestionNotFoundError(
      tag: json['_tag'] as String,
      requestID: json['requestID'] as String,
      message: json['message'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    '_tag': tag,
    'requestID': requestID,
    'message': message,
  };
}

class PermissionRequest {
  /// Создаёт модель из полей.
  PermissionRequest({
    required this.id,
    required this.sessionID,
    required this.permission,
    required this.patterns,
    required this.metadata,
    required this.always,
    this.tool,
  });
  final String id;
  final String sessionID;
  final String permission;
  final List<String> patterns;
  final Map<String, dynamic> metadata;
  final List<String> always;
  final Map<String, dynamic>? tool;

  /// Разбирает JSON в [Object] типа PermissionRequest.
  factory PermissionRequest.fromJson(Map<String, Object?> json) {
    return PermissionRequest(
      id: json['id'] as String,
      sessionID: json['sessionID'] as String,
      permission: json['permission'] as String,
      patterns: (json['patterns'] as List).map((e) => e as String).toList(),
      metadata: (json['metadata'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
      always: (json['always'] as List).map((e) => e as String).toList(),
      tool: (json['tool'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'sessionID': sessionID,
    'permission': permission,
    'patterns': patterns,
    'metadata': metadata,
    'always': always,
    'tool': tool,
  };
}

class PermissionNotFoundError {
  /// Создаёт модель из полей.
  PermissionNotFoundError({
    required this.tag,
    required this.requestID,
    required this.message,
  });
  final String tag;
  final String requestID;
  final String message;

  /// Разбирает JSON в [Object] типа PermissionNotFoundError.
  factory PermissionNotFoundError.fromJson(Map<String, Object?> json) {
    return PermissionNotFoundError(
      tag: json['_tag'] as String,
      requestID: json['requestID'] as String,
      message: json['message'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    '_tag': tag,
    'requestID': requestID,
    'message': message,
  };
}

class ProviderAuthMethod {
  /// Создаёт модель из полей.
  ProviderAuthMethod({required this.type, required this.label, this.prompts});
  final String type;
  final String label;
  final List<dynamic>? prompts;

  /// Разбирает JSON в [Object] типа ProviderAuthMethod.
  factory ProviderAuthMethod.fromJson(Map<String, Object?> json) {
    return ProviderAuthMethod(
      type: json['type'] as String,
      label: json['label'] as String,
      prompts: (json['prompts'] as List?)?.cast<dynamic>(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'label': label,
    'prompts': prompts,
  };
}

class ProviderAuthAuthorization {
  /// Создаёт модель из полей.
  ProviderAuthAuthorization({
    required this.url,
    required this.method,
    required this.instructions,
  });
  final String url;
  final String method;
  final String instructions;

  /// Разбирает JSON в [Object] типа ProviderAuthAuthorization.
  factory ProviderAuthAuthorization.fromJson(Map<String, Object?> json) {
    return ProviderAuthAuthorization(
      url: json['url'] as String,
      method: json['method'] as String,
      instructions: json['instructions'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'url': url,
    'method': method,
    'instructions': instructions,
  };
}

class ProviderAuthError1 {
  /// Создаёт модель из полей.
  ProviderAuthError1({required this.name, required this.data});
  final String name;
  final Map<String, dynamic> data;

  /// Разбирает JSON в [Object] типа ProviderAuthError1.
  factory ProviderAuthError1.fromJson(Map<String, Object?> json) {
    return ProviderAuthError1(
      name: json['name'] as String,
      data: (json['data'] as Map).map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'name': name, 'data': data};
}

class NotFoundError {
  /// Создаёт модель из полей.
  NotFoundError({required this.name, required this.data});
  final String name;
  final Map<String, dynamic> data;

  /// Разбирает JSON в [Object] типа NotFoundError.
  factory NotFoundError.fromJson(Map<String, Object?> json) {
    return NotFoundError(
      name: json['name'] as String,
      data: (json['data'] as Map).map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'name': name, 'data': data};
}

class TextPartInput {
  /// Создаёт модель из полей.
  TextPartInput({
    this.id,
    required this.type,
    required this.text,
    this.synthetic,
    this.ignored,
    this.time,
    this.metadata,
  });
  final String? id;
  final String type;
  final String text;
  final bool? synthetic;
  final bool? ignored;
  final Map<String, dynamic>? time;
  final Map<String, dynamic>? metadata;

  /// Разбирает JSON в [Object] типа TextPartInput.
  factory TextPartInput.fromJson(Map<String, Object?> json) {
    return TextPartInput(
      id: json['id'] as String?,
      type: json['type'] as String,
      text: json['text'] as String,
      synthetic: json['synthetic'] as bool?,
      ignored: json['ignored'] as bool?,
      time: (json['time'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'text': text,
    'synthetic': synthetic,
    'ignored': ignored,
    'time': time,
    'metadata': metadata,
  };
}

class FilePartInput {
  /// Создаёт модель из полей.
  FilePartInput({
    this.id,
    required this.type,
    required this.mime,
    this.filename,
    required this.url,
    this.source,
  });
  final String? id;
  final String type;
  final String mime;
  final String? filename;
  final String url;
  final dynamic source;

  /// Разбирает JSON в [Object] типа FilePartInput.
  factory FilePartInput.fromJson(Map<String, Object?> json) {
    return FilePartInput(
      id: json['id'] as String?,
      type: json['type'] as String,
      mime: json['mime'] as String,
      filename: json['filename'] as String?,
      url: json['url'] as String,
      source: json['source'],
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'mime': mime,
    'filename': filename,
    'url': url,
    'source': source,
  };
}

class AgentPartInput {
  /// Создаёт модель из полей.
  AgentPartInput({
    this.id,
    required this.type,
    required this.name,
    this.source,
  });
  final String? id;
  final String type;
  final String name;
  final Map<String, dynamic>? source;

  /// Разбирает JSON в [Object] типа AgentPartInput.
  factory AgentPartInput.fromJson(Map<String, Object?> json) {
    return AgentPartInput(
      id: json['id'] as String?,
      type: json['type'] as String,
      name: json['name'] as String,
      source: (json['source'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'name': name,
    'source': source,
  };
}

class SubtaskPartInput {
  /// Создаёт модель из полей.
  SubtaskPartInput({
    this.id,
    required this.type,
    required this.prompt,
    required this.description,
    required this.agent,
    this.model,
    this.command,
  });
  final String? id;
  final String type;
  final String prompt;
  final String description;
  final String agent;
  final Map<String, dynamic>? model;
  final String? command;

  /// Разбирает JSON в [Object] типа SubtaskPartInput.
  factory SubtaskPartInput.fromJson(Map<String, Object?> json) {
    return SubtaskPartInput(
      id: json['id'] as String?,
      type: json['type'] as String,
      prompt: json['prompt'] as String,
      description: json['description'] as String,
      agent: json['agent'] as String,
      model: (json['model'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      command: json['command'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'prompt': prompt,
    'description': description,
    'agent': agent,
    'model': model,
    'command': command,
  };
}

class SessionBusyError {
  /// Создаёт модель из полей.
  SessionBusyError({
    required this.tag,
    required this.sessionID,
    required this.message,
  });
  final String tag;
  final String sessionID;
  final String message;

  /// Разбирает JSON в [Object] типа SessionBusyError.
  factory SessionBusyError.fromJson(Map<String, Object?> json) {
    return SessionBusyError(
      tag: json['_tag'] as String,
      sessionID: json['sessionID'] as String,
      message: json['message'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    '_tag': tag,
    'sessionID': sessionID,
    'message': message,
  };
}

class EventTuiPromptAppend {
  /// Создаёт модель из полей.
  EventTuiPromptAppend({required this.type, required this.properties});
  final String type;
  final Map<String, dynamic> properties;

  /// Разбирает JSON в [Object] типа EventTuiPromptAppend.
  factory EventTuiPromptAppend.fromJson(Map<String, Object?> json) {
    return EventTuiPromptAppend(
      type: json['type'] as String,
      properties: (json['properties'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'type': type, 'properties': properties};
}

class EventTuiCommandExecute {
  /// Создаёт модель из полей.
  EventTuiCommandExecute({required this.type, required this.properties});
  final String type;
  final Map<String, dynamic> properties;

  /// Разбирает JSON в [Object] типа EventTuiCommandExecute.
  factory EventTuiCommandExecute.fromJson(Map<String, Object?> json) {
    return EventTuiCommandExecute(
      type: json['type'] as String,
      properties: (json['properties'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'type': type, 'properties': properties};
}

class EventTuiToastShow {
  /// Создаёт модель из полей.
  EventTuiToastShow({required this.type, required this.properties});
  final String type;
  final Map<String, dynamic> properties;

  /// Разбирает JSON в [Object] типа EventTuiToastShow.
  factory EventTuiToastShow.fromJson(Map<String, Object?> json) {
    return EventTuiToastShow(
      type: json['type'] as String,
      properties: (json['properties'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'type': type, 'properties': properties};
}

class EventTuiSessionSelect {
  /// Создаёт модель из полей.
  EventTuiSessionSelect({required this.type, required this.properties});
  final String type;
  final Map<String, dynamic> properties;

  /// Разбирает JSON в [Object] типа EventTuiSessionSelect.
  factory EventTuiSessionSelect.fromJson(Map<String, Object?> json) {
    return EventTuiSessionSelect(
      type: json['type'] as String,
      properties: (json['properties'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'type': type, 'properties': properties};
}

class Workspace {
  /// Создаёт модель из полей.
  Workspace({
    required this.id,
    required this.type,
    required this.name,
    this.branch,
    this.directory,
    this.extra,
    required this.projectID,
    required this.timeUsed,
  });
  final String id;
  final String type;
  final String name;
  final dynamic branch;
  final dynamic directory;
  final dynamic extra;
  final String projectID;
  final dynamic timeUsed;

  /// Разбирает JSON в [Object] типа Workspace.
  factory Workspace.fromJson(Map<String, Object?> json) {
    return Workspace(
      id: json['id'] as String,
      type: json['type'] as String,
      name: json['name'] as String,
      branch: json['branch'],
      directory: json['directory'],
      extra: json['extra'],
      projectID: json['projectID'] as String,
      timeUsed: json['timeUsed'],
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'name': name,
    'branch': branch,
    'directory': directory,
    'extra': extra,
    'projectID': projectID,
    'timeUsed': timeUsed,
  };
}

class WorkspaceCreateError {
  /// Создаёт модель из полей.
  WorkspaceCreateError({required this.name, required this.data});
  final String name;
  final Map<String, dynamic> data;

  /// Разбирает JSON в [Object] типа WorkspaceCreateError.
  factory WorkspaceCreateError.fromJson(Map<String, Object?> json) {
    return WorkspaceCreateError(
      name: json['name'] as String,
      data: (json['data'] as Map).map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'name': name, 'data': data};
}

class WorkspaceWarpError {
  /// Создаёт модель из полей.
  WorkspaceWarpError({required this.name, required this.data});
  final String name;
  final Map<String, dynamic> data;

  /// Разбирает JSON в [Object] типа WorkspaceWarpError.
  factory WorkspaceWarpError.fromJson(Map<String, Object?> json) {
    return WorkspaceWarpError(
      name: json['name'] as String,
      data: (json['data'] as Map).map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'name': name, 'data': data};
}

class UnauthorizedError {
  /// Создаёт модель из полей.
  UnauthorizedError({required this.tag, required this.message});
  final String tag;
  final String message;

  /// Разбирает JSON в [Object] типа UnauthorizedError.
  factory UnauthorizedError.fromJson(Map<String, Object?> json) {
    return UnauthorizedError(
      tag: json['_tag'] as String,
      message: json['message'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'_tag': tag, 'message': message};
}

class ModelRef {
  /// Создаёт модель из полей.
  ModelRef({required this.id, required this.providerID, this.variant});
  final String id;
  final String providerID;
  final String? variant;

  /// Разбирает JSON в [Object] типа ModelRef.
  factory ModelRef.fromJson(Map<String, Object?> json) {
    return ModelRef(
      id: json['id'] as String,
      providerID: json['providerID'] as String,
      variant: json['variant'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'providerID': providerID,
    'variant': variant,
  };
}

class LocationRef {
  /// Создаёт модель из полей.
  LocationRef({required this.directory, this.workspaceID});
  final String directory;
  final String? workspaceID;

  /// Разбирает JSON в [Object] типа LocationRef.
  factory LocationRef.fromJson(Map<String, Object?> json) {
    return LocationRef(
      directory: json['directory'] as String,
      workspaceID: json['workspaceID'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'directory': directory,
    'workspaceID': workspaceID,
  };
}

class FileDiff {
  /// Создаёт модель из полей.
  FileDiff({
    required this.path,
    required this.status,
    required this.additions,
    required this.deletions,
    required this.patch,
  });
  final String path;
  final String status;
  final int additions;
  final int deletions;
  final String patch;

  /// Разбирает JSON в [Object] типа FileDiff.
  factory FileDiff.fromJson(Map<String, Object?> json) {
    return FileDiff(
      path: json['path'] as String,
      status: json['status'] as String,
      additions: (json['additions'] as num).toInt(),
      deletions: (json['deletions'] as num).toInt(),
      patch: json['patch'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'path': path,
    'status': status,
    'additions': additions,
    'deletions': deletions,
    'patch': patch,
  };
}

class RevertState {
  /// Создаёт модель из полей.
  RevertState({
    required this.messageID,
    this.partID,
    this.snapshot,
    this.diff,
    this.files,
  });
  final String messageID;
  final String? partID;
  final String? snapshot;
  final String? diff;
  final List<FileDiff>? files;

  /// Разбирает JSON в [Object] типа RevertState.
  factory RevertState.fromJson(Map<String, Object?> json) {
    return RevertState(
      messageID: json['messageID'] as String,
      partID: json['partID'] as String?,
      snapshot: json['snapshot'] as String?,
      diff: json['diff'] as String?,
      files: (json['files'] as List?)
          ?.map((e) => FileDiff.fromJson(e as Map<String, Object?>))
          .toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'messageID': messageID,
    'partID': partID,
    'snapshot': snapshot,
    'diff': diff,
    'files': files?.map((e) => e.toJson()).toList(),
  };
}

class SessionV2Info {
  /// Создаёт модель из полей.
  SessionV2Info({
    required this.id,
    this.parentID,
    required this.projectID,
    this.agent,
    this.model,
    required this.cost,
    required this.tokens,
    required this.time,
    required this.title,
    required this.location,
    this.subpath,
    this.revert,
  });
  final String id;
  final String? parentID;
  final String projectID;
  final String? agent;
  final ModelRef? model;
  final double cost;
  final Map<String, dynamic> tokens;
  final Map<String, dynamic> time;
  final String title;
  final LocationRef location;
  final String? subpath;
  final RevertState? revert;

  /// Разбирает JSON в [Object] типа SessionV2Info.
  factory SessionV2Info.fromJson(Map<String, Object?> json) {
    return SessionV2Info(
      id: json['id'] as String,
      parentID: json['parentID'] as String?,
      projectID: json['projectID'] as String,
      agent: json['agent'] as String?,
      model: (json['model'] as Map<String, Object?>?) == null
          ? null
          : ModelRef.fromJson(json['model'] as Map<String, Object?>),
      cost: (json['cost'] as num).toDouble(),
      tokens: (json['tokens'] as Map).map((k, v) => MapEntry(k as String, v)),
      time: (json['time'] as Map).map((k, v) => MapEntry(k as String, v)),
      title: json['title'] as String,
      location: LocationRef.fromJson(json['location'] as Map<String, Object?>),
      subpath: json['subpath'] as String?,
      revert: (json['revert'] as Map<String, Object?>?) == null
          ? null
          : RevertState.fromJson(json['revert'] as Map<String, Object?>),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'parentID': parentID,
    'projectID': projectID,
    'agent': agent,
    'model': model?.toJson(),
    'cost': cost,
    'tokens': tokens,
    'time': time,
    'title': title,
    'location': location?.toJson(),
    'subpath': subpath,
    'revert': revert?.toJson(),
  };
}

class SessionsResponse {
  /// Создаёт модель из полей.
  SessionsResponse({required this.data, required this.cursor});
  final List<SessionV2Info> data;
  final Map<String, dynamic> cursor;

  /// Разбирает JSON в [Object] типа SessionsResponse.
  factory SessionsResponse.fromJson(Map<String, Object?> json) {
    return SessionsResponse(
      data: (json['data'] as List)
          .map((e) => SessionV2Info.fromJson(e as Map<String, Object?>))
          .toList(),
      cursor: (json['cursor'] as Map).map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'data': data?.map((e) => e.toJson()).toList(),
    'cursor': cursor,
  };
}

class InvalidCursorError {
  /// Создаёт модель из полей.
  InvalidCursorError({required this.tag, required this.message});
  final String tag;
  final String message;

  /// Разбирает JSON в [Object] типа InvalidCursorError.
  factory InvalidCursorError.fromJson(Map<String, Object?> json) {
    return InvalidCursorError(
      tag: json['_tag'] as String,
      message: json['message'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'_tag': tag, 'message': message};
}

class SessionActive {
  /// Создаёт модель из полей.
  SessionActive({required this.type});
  final String type;

  /// Разбирает JSON в [Object] типа SessionActive.
  factory SessionActive.fromJson(Map<String, Object?> json) {
    return SessionActive(type: json['type'] as String);
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'type': type};
}

class SessionNotFoundError {
  /// Создаёт модель из полей.
  SessionNotFoundError({
    required this.tag,
    required this.sessionID,
    required this.message,
  });
  final String tag;
  final String sessionID;
  final String message;

  /// Разбирает JSON в [Object] типа SessionNotFoundError.
  factory SessionNotFoundError.fromJson(Map<String, Object?> json) {
    return SessionNotFoundError(
      tag: json['_tag'] as String,
      sessionID: json['sessionID'] as String,
      message: json['message'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    '_tag': tag,
    'sessionID': sessionID,
    'message': message,
  };
}

class PromptInputFileAttachment {
  /// Создаёт модель из полей.
  PromptInputFileAttachment({
    required this.uri,
    this.name,
    this.description,
    this.source,
  });
  final String uri;
  final String? name;
  final String? description;
  final PromptSource? source;

  /// Разбирает JSON в [Object] типа PromptInputFileAttachment.
  factory PromptInputFileAttachment.fromJson(Map<String, Object?> json) {
    return PromptInputFileAttachment(
      uri: json['uri'] as String,
      name: json['name'] as String?,
      description: json['description'] as String?,
      source: (json['source'] as Map<String, Object?>?) == null
          ? null
          : PromptSource.fromJson(json['source'] as Map<String, Object?>),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'uri': uri,
    'name': name,
    'description': description,
    'source': source?.toJson(),
  };
}

class PromptInput {
  /// Создаёт модель из полей.
  PromptInput({required this.text, this.files, this.agents});
  final String text;
  final List<PromptInputFileAttachment>? files;
  final List<PromptAgentAttachment>? agents;

  /// Разбирает JSON в [Object] типа PromptInput.
  factory PromptInput.fromJson(Map<String, Object?> json) {
    return PromptInput(
      text: json['text'] as String,
      files: (json['files'] as List?)
          ?.map(
            (e) =>
                PromptInputFileAttachment.fromJson(e as Map<String, Object?>),
          )
          .toList(),
      agents: (json['agents'] as List?)
          ?.map(
            (e) => PromptAgentAttachment.fromJson(e as Map<String, Object?>),
          )
          .toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'text': text,
    'files': files?.map((e) => e.toJson()).toList(),
    'agents': agents?.map((e) => e.toJson()).toList(),
  };
}

class ConflictError {
  /// Создаёт модель из полей.
  ConflictError({required this.tag, required this.message, this.resource});
  final String tag;
  final String message;
  final String? resource;

  /// Разбирает JSON в [Object] типа ConflictError.
  factory ConflictError.fromJson(Map<String, Object?> json) {
    return ConflictError(
      tag: json['_tag'] as String,
      message: json['message'] as String,
      resource: json['resource'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    '_tag': tag,
    'message': message,
    'resource': resource,
  };
}

class ServiceUnavailableError {
  /// Создаёт модель из полей.
  ServiceUnavailableError({
    required this.tag,
    required this.message,
    this.service,
  });
  final String tag;
  final String message;
  final String? service;

  /// Разбирает JSON в [Object] типа ServiceUnavailableError.
  factory ServiceUnavailableError.fromJson(Map<String, Object?> json) {
    return ServiceUnavailableError(
      tag: json['_tag'] as String,
      message: json['message'] as String,
      service: json['service'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    '_tag': tag,
    'message': message,
    'service': service,
  };
}

class MessageNotFoundError {
  /// Создаёт модель из полей.
  MessageNotFoundError({
    required this.tag,
    required this.sessionID,
    required this.messageID,
    required this.message,
  });
  final String tag;
  final String sessionID;
  final String messageID;
  final String message;

  /// Разбирает JSON в [Object] типа MessageNotFoundError.
  factory MessageNotFoundError.fromJson(Map<String, Object?> json) {
    return MessageNotFoundError(
      tag: json['_tag'] as String,
      sessionID: json['sessionID'] as String,
      messageID: json['messageID'] as String,
      message: json['message'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    '_tag': tag,
    'sessionID': sessionID,
    'messageID': messageID,
    'message': message,
  };
}

class UnknownError1 {
  /// Создаёт модель из полей.
  UnknownError1({required this.tag, required this.message, this.ref});
  final String tag;
  final String message;
  final String? ref;

  /// Разбирает JSON в [Object] типа UnknownError1.
  factory UnknownError1.fromJson(Map<String, Object?> json) {
    return UnknownError1(
      tag: json['_tag'] as String,
      message: json['message'] as String,
      ref: json['ref'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    '_tag': tag,
    'message': message,
    'ref': ref,
  };
}

class SessionHistory {
  /// Создаёт модель из полей.
  SessionHistory({required this.data, required this.hasMore});
  final List<dynamic> data;
  final bool hasMore;

  /// Разбирает JSON в [Object] типа SessionHistory.
  factory SessionHistory.fromJson(Map<String, Object?> json) {
    return SessionHistory(
      data: (json['data'] as List).map((e) => e).toList(),
      hasMore: json['hasMore'] as bool,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'data': data, 'hasMore': hasMore};
}

class SessionMessagesResponse {
  /// Создаёт модель из полей.
  SessionMessagesResponse({required this.data, required this.cursor});
  final List<dynamic> data;
  final Map<String, dynamic> cursor;

  /// Разбирает JSON в [Object] типа SessionMessagesResponse.
  factory SessionMessagesResponse.fromJson(Map<String, Object?> json) {
    return SessionMessagesResponse(
      data: (json['data'] as List).map((e) => e).toList(),
      cursor: (json['cursor'] as Map).map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'data': data, 'cursor': cursor};
}

class ProviderNotFoundError {
  /// Создаёт модель из полей.
  ProviderNotFoundError({
    required this.tag,
    required this.providerID,
    required this.message,
  });
  final String tag;
  final String providerID;
  final String message;

  /// Разбирает JSON в [Object] типа ProviderNotFoundError.
  factory ProviderNotFoundError.fromJson(Map<String, Object?> json) {
    return ProviderNotFoundError(
      tag: json['_tag'] as String,
      providerID: json['providerID'] as String,
      message: json['message'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    '_tag': tag,
    'providerID': providerID,
    'message': message,
  };
}

class SessionStatus {
  /// Создаёт модель из полей.
  SessionStatus({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionStatus.
  factory SessionStatus.fromJson(Map<String, Object?> json) {
    return SessionStatus(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class ForbiddenError {
  /// Создаёт модель из полей.
  ForbiddenError({required this.tag, required this.message});
  final String tag;
  final String message;

  /// Разбирает JSON в [Object] типа ForbiddenError.
  factory ForbiddenError.fromJson(Map<String, Object?> json) {
    return ForbiddenError(
      tag: json['_tag'] as String,
      message: json['message'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'_tag': tag, 'message': message};
}

class ProjectCopyError {
  /// Создаёт модель из полей.
  ProjectCopyError({required this.name, required this.data});
  final String name;
  final Map<String, dynamic> data;

  /// Разбирает JSON в [Object] типа ProjectCopyError.
  factory ProjectCopyError.fromJson(Map<String, Object?> json) {
    return ProjectCopyError(
      name: json['name'] as String,
      data: (json['data'] as Map).map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'name': name, 'data': data};
}

class EffectHttpApiErrorForbidden {
  /// Создаёт модель из полей.
  EffectHttpApiErrorForbidden({required this.tag});
  final String tag;

  /// Разбирает JSON в [Object] типа EffectHttpApiErrorForbidden.
  factory EffectHttpApiErrorForbidden.fromJson(Map<String, Object?> json) {
    return EffectHttpApiErrorForbidden(tag: json['_tag'] as String);
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'_tag': tag};
}

class IntegrationRef {
  /// Создаёт модель из полей.
  IntegrationRef({required this.id, required this.name});
  final String id;
  final String name;

  /// Разбирает JSON в [Object] типа IntegrationRef.
  factory IntegrationRef.fromJson(Map<String, Object?> json) {
    return IntegrationRef(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'id': id, 'name': name};
}

class MoveSessionDestination {
  /// Создаёт модель из полей.
  MoveSessionDestination({required this.directory});
  final String directory;

  /// Разбирает JSON в [Object] типа MoveSessionDestination.
  factory MoveSessionDestination.fromJson(Map<String, Object?> json) {
    return MoveSessionDestination(directory: json['directory'] as String);
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'directory': directory};
}

class SessionErrorUnknown {
  /// Создаёт модель из полей.
  SessionErrorUnknown({required this.type, required this.message});
  final String type;
  final String message;

  /// Разбирает JSON в [Object] типа SessionErrorUnknown.
  factory SessionErrorUnknown.fromJson(Map<String, Object?> json) {
    return SessionErrorUnknown(
      type: json['type'] as String,
      message: json['message'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'type': type, 'message': message};
}

class ToolTextContent {
  /// Создаёт модель из полей.
  ToolTextContent({this.type, this.text});
  final String? type;
  final String? text;

  /// Разбирает JSON в [Object] типа ToolTextContent.
  factory ToolTextContent.fromJson(Map<String, Object?> json) {
    return ToolTextContent(
      type: json['type'] as String?,
      text: json['text'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'type': type, 'text': text};
}

class ToolFileContent {
  /// Создаёт модель из полей.
  ToolFileContent({this.type, this.uri, this.mime, this.name});
  final String? type;
  final String? uri;
  final String? mime;
  final String? name;

  /// Разбирает JSON в [Object] типа ToolFileContent.
  factory ToolFileContent.fromJson(Map<String, Object?> json) {
    return ToolFileContent(
      type: json['type'] as String?,
      uri: json['uri'] as String?,
      mime: json['mime'] as String?,
      name: json['name'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'uri': uri,
    'mime': mime,
    'name': name,
  };
}

class SessionNextRetryError {
  /// Создаёт модель из полей.
  SessionNextRetryError({
    required this.message,
    this.statusCode,
    required this.isRetryable,
    this.responseHeaders,
    this.responseBody,
    this.metadata,
  });
  final String message;
  final double? statusCode;
  final bool isRetryable;
  final Map<String, String>? responseHeaders;
  final String? responseBody;
  final Map<String, String>? metadata;

  /// Разбирает JSON в [Object] типа SessionNextRetryError.
  factory SessionNextRetryError.fromJson(Map<String, Object?> json) {
    return SessionNextRetryError(
      message: json['message'] as String,
      statusCode: (json['statusCode'] as num?)?.toDouble(),
      isRetryable: json['isRetryable'] as bool,
      responseHeaders: (json['responseHeaders'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v as String),
      ),
      responseBody: json['responseBody'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v as String),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'message': message,
    'statusCode': statusCode,
    'isRetryable': isRetryable,
    'responseHeaders': responseHeaders,
    'responseBody': responseBody,
    'metadata': metadata,
  };
}

class PermissionV2Source {
  /// Создаёт модель из полей.
  PermissionV2Source({
    required this.type,
    required this.messageID,
    required this.callID,
  });
  final String type;
  final String messageID;
  final String callID;

  /// Разбирает JSON в [Object] типа PermissionV2Source.
  factory PermissionV2Source.fromJson(Map<String, Object?> json) {
    return PermissionV2Source(
      type: json['type'] as String,
      messageID: json['messageID'] as String,
      callID: json['callID'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'messageID': messageID,
    'callID': callID,
  };
}

class QuestionV2Option {
  /// Создаёт модель из полей.
  QuestionV2Option({required this.label, required this.description});
  final String label;
  final String description;

  /// Разбирает JSON в [Object] типа QuestionV2Option.
  factory QuestionV2Option.fromJson(Map<String, Object?> json) {
    return QuestionV2Option(
      label: json['label'] as String,
      description: json['description'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'label': label, 'description': description};
}

class QuestionV2Info {
  /// Создаёт модель из полей.
  QuestionV2Info({
    required this.question,
    required this.header,
    required this.options,
    this.multiple,
    this.custom,
  });
  final String question;
  final String header;
  final List<QuestionV2Option> options;
  final bool? multiple;
  final bool? custom;

  /// Разбирает JSON в [Object] типа QuestionV2Info.
  factory QuestionV2Info.fromJson(Map<String, Object?> json) {
    return QuestionV2Info(
      question: json['question'] as String,
      header: json['header'] as String,
      options: (json['options'] as List)
          .map((e) => QuestionV2Option.fromJson(e as Map<String, Object?>))
          .toList(),
      multiple: json['multiple'] as bool?,
      custom: json['custom'] as bool?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'question': question,
    'header': header,
    'options': options?.map((e) => e.toJson()).toList(),
    'multiple': multiple,
    'custom': custom,
  };
}

class QuestionV2Tool {
  /// Создаёт модель из полей.
  QuestionV2Tool({required this.messageID, required this.callID});
  final String messageID;
  final String callID;

  /// Разбирает JSON в [Object] типа QuestionV2Tool.
  factory QuestionV2Tool.fromJson(Map<String, Object?> json) {
    return QuestionV2Tool(
      messageID: json['messageID'] as String,
      callID: json['callID'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'messageID': messageID, 'callID': callID};
}

class EventServerInstanceDisposed {
  /// Создаёт модель из полей.
  EventServerInstanceDisposed({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventServerInstanceDisposed.
  factory EventServerInstanceDisposed.fromJson(Map<String, Object?> json) {
    return EventServerInstanceDisposed(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class SyncEventSessionCreated {
  /// Создаёт модель из полей.
  SyncEventSessionCreated({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionCreated.
  factory SyncEventSessionCreated.fromJson(Map<String, Object?> json) {
    return SyncEventSessionCreated(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionUpdated {
  /// Создаёт модель из полей.
  SyncEventSessionUpdated({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionUpdated.
  factory SyncEventSessionUpdated.fromJson(Map<String, Object?> json) {
    return SyncEventSessionUpdated(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionDeleted {
  /// Создаёт модель из полей.
  SyncEventSessionDeleted({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionDeleted.
  factory SyncEventSessionDeleted.fromJson(Map<String, Object?> json) {
    return SyncEventSessionDeleted(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventMessageUpdated {
  /// Создаёт модель из полей.
  SyncEventMessageUpdated({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventMessageUpdated.
  factory SyncEventMessageUpdated.fromJson(Map<String, Object?> json) {
    return SyncEventMessageUpdated(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventMessageRemoved {
  /// Создаёт модель из полей.
  SyncEventMessageRemoved({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventMessageRemoved.
  factory SyncEventMessageRemoved.fromJson(Map<String, Object?> json) {
    return SyncEventMessageRemoved(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventMessagePartUpdated {
  /// Создаёт модель из полей.
  SyncEventMessagePartUpdated({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventMessagePartUpdated.
  factory SyncEventMessagePartUpdated.fromJson(Map<String, Object?> json) {
    return SyncEventMessagePartUpdated(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventMessagePartRemoved {
  /// Создаёт модель из полей.
  SyncEventMessagePartRemoved({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventMessagePartRemoved.
  factory SyncEventMessagePartRemoved.fromJson(Map<String, Object?> json) {
    return SyncEventMessagePartRemoved(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionNextAgentSwitched {
  /// Создаёт модель из полей.
  SyncEventSessionNextAgentSwitched({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionNextAgentSwitched.
  factory SyncEventSessionNextAgentSwitched.fromJson(
    Map<String, Object?> json,
  ) {
    return SyncEventSessionNextAgentSwitched(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionNextModelSwitched {
  /// Создаёт модель из полей.
  SyncEventSessionNextModelSwitched({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionNextModelSwitched.
  factory SyncEventSessionNextModelSwitched.fromJson(
    Map<String, Object?> json,
  ) {
    return SyncEventSessionNextModelSwitched(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionNextMoved {
  /// Создаёт модель из полей.
  SyncEventSessionNextMoved({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionNextMoved.
  factory SyncEventSessionNextMoved.fromJson(Map<String, Object?> json) {
    return SyncEventSessionNextMoved(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionNextPrompted {
  /// Создаёт модель из полей.
  SyncEventSessionNextPrompted({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionNextPrompted.
  factory SyncEventSessionNextPrompted.fromJson(Map<String, Object?> json) {
    return SyncEventSessionNextPrompted(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionNextPromptAdmitted {
  /// Создаёт модель из полей.
  SyncEventSessionNextPromptAdmitted({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionNextPromptAdmitted.
  factory SyncEventSessionNextPromptAdmitted.fromJson(
    Map<String, Object?> json,
  ) {
    return SyncEventSessionNextPromptAdmitted(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionNextContextUpdated {
  /// Создаёт модель из полей.
  SyncEventSessionNextContextUpdated({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionNextContextUpdated.
  factory SyncEventSessionNextContextUpdated.fromJson(
    Map<String, Object?> json,
  ) {
    return SyncEventSessionNextContextUpdated(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionNextSynthetic {
  /// Создаёт модель из полей.
  SyncEventSessionNextSynthetic({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionNextSynthetic.
  factory SyncEventSessionNextSynthetic.fromJson(Map<String, Object?> json) {
    return SyncEventSessionNextSynthetic(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionNextShellStarted {
  /// Создаёт модель из полей.
  SyncEventSessionNextShellStarted({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionNextShellStarted.
  factory SyncEventSessionNextShellStarted.fromJson(Map<String, Object?> json) {
    return SyncEventSessionNextShellStarted(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionNextShellEnded {
  /// Создаёт модель из полей.
  SyncEventSessionNextShellEnded({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionNextShellEnded.
  factory SyncEventSessionNextShellEnded.fromJson(Map<String, Object?> json) {
    return SyncEventSessionNextShellEnded(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionNextStepStarted {
  /// Создаёт модель из полей.
  SyncEventSessionNextStepStarted({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionNextStepStarted.
  factory SyncEventSessionNextStepStarted.fromJson(Map<String, Object?> json) {
    return SyncEventSessionNextStepStarted(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionNextStepEnded {
  /// Создаёт модель из полей.
  SyncEventSessionNextStepEnded({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionNextStepEnded.
  factory SyncEventSessionNextStepEnded.fromJson(Map<String, Object?> json) {
    return SyncEventSessionNextStepEnded(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionNextStepFailed {
  /// Создаёт модель из полей.
  SyncEventSessionNextStepFailed({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionNextStepFailed.
  factory SyncEventSessionNextStepFailed.fromJson(Map<String, Object?> json) {
    return SyncEventSessionNextStepFailed(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionNextTextStarted {
  /// Создаёт модель из полей.
  SyncEventSessionNextTextStarted({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionNextTextStarted.
  factory SyncEventSessionNextTextStarted.fromJson(Map<String, Object?> json) {
    return SyncEventSessionNextTextStarted(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionNextTextEnded {
  /// Создаёт модель из полей.
  SyncEventSessionNextTextEnded({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionNextTextEnded.
  factory SyncEventSessionNextTextEnded.fromJson(Map<String, Object?> json) {
    return SyncEventSessionNextTextEnded(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionNextReasoningStarted {
  /// Создаёт модель из полей.
  SyncEventSessionNextReasoningStarted({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionNextReasoningStarted.
  factory SyncEventSessionNextReasoningStarted.fromJson(
    Map<String, Object?> json,
  ) {
    return SyncEventSessionNextReasoningStarted(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionNextReasoningEnded {
  /// Создаёт модель из полей.
  SyncEventSessionNextReasoningEnded({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionNextReasoningEnded.
  factory SyncEventSessionNextReasoningEnded.fromJson(
    Map<String, Object?> json,
  ) {
    return SyncEventSessionNextReasoningEnded(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionNextToolInputStarted {
  /// Создаёт модель из полей.
  SyncEventSessionNextToolInputStarted({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionNextToolInputStarted.
  factory SyncEventSessionNextToolInputStarted.fromJson(
    Map<String, Object?> json,
  ) {
    return SyncEventSessionNextToolInputStarted(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionNextToolInputEnded {
  /// Создаёт модель из полей.
  SyncEventSessionNextToolInputEnded({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionNextToolInputEnded.
  factory SyncEventSessionNextToolInputEnded.fromJson(
    Map<String, Object?> json,
  ) {
    return SyncEventSessionNextToolInputEnded(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionNextToolCalled {
  /// Создаёт модель из полей.
  SyncEventSessionNextToolCalled({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionNextToolCalled.
  factory SyncEventSessionNextToolCalled.fromJson(Map<String, Object?> json) {
    return SyncEventSessionNextToolCalled(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionNextToolProgress {
  /// Создаёт модель из полей.
  SyncEventSessionNextToolProgress({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionNextToolProgress.
  factory SyncEventSessionNextToolProgress.fromJson(Map<String, Object?> json) {
    return SyncEventSessionNextToolProgress(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionNextToolSuccess {
  /// Создаёт модель из полей.
  SyncEventSessionNextToolSuccess({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionNextToolSuccess.
  factory SyncEventSessionNextToolSuccess.fromJson(Map<String, Object?> json) {
    return SyncEventSessionNextToolSuccess(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionNextToolFailed {
  /// Создаёт модель из полей.
  SyncEventSessionNextToolFailed({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionNextToolFailed.
  factory SyncEventSessionNextToolFailed.fromJson(Map<String, Object?> json) {
    return SyncEventSessionNextToolFailed(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionNextRetried {
  /// Создаёт модель из полей.
  SyncEventSessionNextRetried({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionNextRetried.
  factory SyncEventSessionNextRetried.fromJson(Map<String, Object?> json) {
    return SyncEventSessionNextRetried(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionNextCompactionStarted {
  /// Создаёт модель из полей.
  SyncEventSessionNextCompactionStarted({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionNextCompactionStarted.
  factory SyncEventSessionNextCompactionStarted.fromJson(
    Map<String, Object?> json,
  ) {
    return SyncEventSessionNextCompactionStarted(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionNextCompactionEnded {
  /// Создаёт модель из полей.
  SyncEventSessionNextCompactionEnded({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionNextCompactionEnded.
  factory SyncEventSessionNextCompactionEnded.fromJson(
    Map<String, Object?> json,
  ) {
    return SyncEventSessionNextCompactionEnded(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionNextRevertStaged {
  /// Создаёт модель из полей.
  SyncEventSessionNextRevertStaged({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionNextRevertStaged.
  factory SyncEventSessionNextRevertStaged.fromJson(Map<String, Object?> json) {
    return SyncEventSessionNextRevertStaged(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionNextRevertCleared {
  /// Создаёт модель из полей.
  SyncEventSessionNextRevertCleared({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionNextRevertCleared.
  factory SyncEventSessionNextRevertCleared.fromJson(
    Map<String, Object?> json,
  ) {
    return SyncEventSessionNextRevertCleared(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class SyncEventSessionNextRevertCommitted {
  /// Создаёт модель из полей.
  SyncEventSessionNextRevertCommitted({
    required this.type,
    required this.id,
    required this.syncEvent,
  });
  final String type;
  final String id;
  final Map<String, dynamic> syncEvent;

  /// Разбирает JSON в [Object] типа SyncEventSessionNextRevertCommitted.
  factory SyncEventSessionNextRevertCommitted.fromJson(
    Map<String, Object?> json,
  ) {
    return SyncEventSessionNextRevertCommitted(
      type: json['type'] as String,
      id: json['id'] as String,
      syncEvent: (json['syncEvent'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'syncEvent': syncEvent,
  };
}

class ConfigV2ReferenceGit {
  /// Создаёт модель из полей.
  ConfigV2ReferenceGit({
    required this.repository,
    this.branch,
    this.description,
    this.hidden,
  });
  final String repository;
  final String? branch;
  final String? description;
  final bool? hidden;

  /// Разбирает JSON в [Object] типа ConfigV2ReferenceGit.
  factory ConfigV2ReferenceGit.fromJson(Map<String, Object?> json) {
    return ConfigV2ReferenceGit(
      repository: json['repository'] as String,
      branch: json['branch'] as String?,
      description: json['description'] as String?,
      hidden: json['hidden'] as bool?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'repository': repository,
    'branch': branch,
    'description': description,
    'hidden': hidden,
  };
}

class ConfigV2ReferenceLocal {
  /// Создаёт модель из полей.
  ConfigV2ReferenceLocal({required this.path, this.description, this.hidden});
  final String path;
  final String? description;
  final bool? hidden;

  /// Разбирает JSON в [Object] типа ConfigV2ReferenceLocal.
  factory ConfigV2ReferenceLocal.fromJson(Map<String, Object?> json) {
    return ConfigV2ReferenceLocal(
      path: json['path'] as String,
      description: json['description'] as String?,
      hidden: json['hidden'] as bool?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'path': path,
    'description': description,
    'hidden': hidden,
  };
}

class ConfigV2ExperimentalPolicy {
  /// Создаёт модель из полей.
  ConfigV2ExperimentalPolicy({
    required this.action,
    required this.effect,
    required this.resource,
  });
  final String action;
  final String effect;
  final String resource;

  /// Разбирает JSON в [Object] типа ConfigV2ExperimentalPolicy.
  factory ConfigV2ExperimentalPolicy.fromJson(Map<String, Object?> json) {
    return ConfigV2ExperimentalPolicy(
      action: json['action'] as String,
      effect: json['effect'] as String,
      resource: json['resource'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'action': action,
    'effect': effect,
    'resource': resource,
  };
}

class PtyTicketConnectToken {
  /// Создаёт модель из полей.
  PtyTicketConnectToken({required this.ticket, required this.expires_in});
  final String ticket;
  final int expires_in;

  /// Разбирает JSON в [Object] типа PtyTicketConnectToken.
  factory PtyTicketConnectToken.fromJson(Map<String, Object?> json) {
    return PtyTicketConnectToken(
      ticket: json['ticket'] as String,
      expires_in: (json['expires_in'] as num).toInt(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'ticket': ticket, 'expires_in': expires_in};
}

class WorkspaceEventConnectionStatus {
  /// Создаёт модель из полей.
  WorkspaceEventConnectionStatus({
    required this.workspaceID,
    required this.status,
  });
  final String workspaceID;
  final String status;

  /// Разбирает JSON в [Object] типа WorkspaceEventConnectionStatus.
  factory WorkspaceEventConnectionStatus.fromJson(Map<String, Object?> json) {
    return WorkspaceEventConnectionStatus(
      workspaceID: json['workspaceID'] as String,
      status: json['status'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'workspaceID': workspaceID,
    'status': status,
  };
}

class LocationInfo {
  /// Создаёт модель из полей.
  LocationInfo({
    required this.directory,
    this.workspaceID,
    required this.project,
  });
  final String directory;
  final String? workspaceID;
  final Map<String, dynamic> project;

  /// Разбирает JSON в [Object] типа LocationInfo.
  factory LocationInfo.fromJson(Map<String, Object?> json) {
    return LocationInfo(
      directory: json['directory'] as String,
      workspaceID: json['workspaceID'] as String?,
      project: (json['project'] as Map).map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'directory': directory,
    'workspaceID': workspaceID,
    'project': project,
  };
}

class ProviderRequest {
  /// Создаёт модель из полей.
  ProviderRequest({required this.headers, required this.body});
  final Map<String, String> headers;
  final Map<String, dynamic> body;

  /// Разбирает JSON в [Object] типа ProviderRequest.
  factory ProviderRequest.fromJson(Map<String, Object?> json) {
    return ProviderRequest(
      headers: (json['headers'] as Map).map(
        (k, v) => MapEntry(k as String, v as String),
      ),
      body: (json['body'] as Map).map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'headers': headers, 'body': body};
}

class PermissionV2Rule {
  /// Создаёт модель из полей.
  PermissionV2Rule({
    required this.action,
    required this.resource,
    required this.effect,
  });
  final String action;
  final String resource;
  final String effect;

  /// Разбирает JSON в [Object] типа PermissionV2Rule.
  factory PermissionV2Rule.fromJson(Map<String, Object?> json) {
    return PermissionV2Rule(
      action: json['action'] as String,
      resource: json['resource'] as String,
      effect: json['effect'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'action': action,
    'resource': resource,
    'effect': effect,
  };
}

class AgentV2Info {
  /// Создаёт модель из полей.
  AgentV2Info({
    required this.id,
    this.model,
    required this.request,
    this.system,
    this.description,
    required this.mode,
    required this.hidden,
    this.color,
    this.steps,
    required this.permissions,
  });
  final String id;
  final ModelRef? model;
  final ProviderRequest request;
  final String? system;
  final String? description;
  final String mode;
  final bool hidden;
  final dynamic color;
  final int? steps;
  final PermissionV2Rule permissions;

  /// Разбирает JSON в [Object] типа AgentV2Info.
  factory AgentV2Info.fromJson(Map<String, Object?> json) {
    return AgentV2Info(
      id: json['id'] as String,
      model: (json['model'] as Map<String, Object?>?) == null
          ? null
          : ModelRef.fromJson(json['model'] as Map<String, Object?>),
      request: ProviderRequest.fromJson(
        json['request'] as Map<String, Object?>,
      ),
      system: json['system'] as String?,
      description: json['description'] as String?,
      mode: json['mode'] as String,
      hidden: json['hidden'] as bool,
      color: json['color'],
      steps: (json['steps'] as num?)?.toInt(),
      permissions: PermissionV2Rule.fromJson(
        json['permissions'] as Map<String, Object?>,
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'model': model?.toJson(),
    'request': request?.toJson(),
    'system': system,
    'description': description,
    'mode': mode,
    'hidden': hidden,
    'color': color,
    'steps': steps,
    'permissions': permissions?.toJson(),
  };
}

class SessionInputAdmitted {
  /// Создаёт модель из полей.
  SessionInputAdmitted({
    required this.admittedSeq,
    required this.id,
    required this.sessionID,
    required this.prompt,
    required this.delivery,
    required this.timeCreated,
    this.promotedSeq,
  });
  final int admittedSeq;
  final String id;
  final String sessionID;
  final Prompt prompt;
  final String delivery;
  final double timeCreated;
  final int? promotedSeq;

  /// Разбирает JSON в [Object] типа SessionInputAdmitted.
  factory SessionInputAdmitted.fromJson(Map<String, Object?> json) {
    return SessionInputAdmitted(
      admittedSeq: (json['admittedSeq'] as num).toInt(),
      id: json['id'] as String,
      sessionID: json['sessionID'] as String,
      prompt: Prompt.fromJson(json['prompt'] as Map<String, Object?>),
      delivery: json['delivery'] as String,
      timeCreated: (json['timeCreated'] as num).toDouble(),
      promotedSeq: (json['promotedSeq'] as num?)?.toInt(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'admittedSeq': admittedSeq,
    'id': id,
    'sessionID': sessionID,
    'prompt': prompt?.toJson(),
    'delivery': delivery,
    'timeCreated': timeCreated,
    'promotedSeq': promotedSeq,
  };
}

class SessionMessageAgentSwitched {
  /// Создаёт модель из полей.
  SessionMessageAgentSwitched({
    this.id,
    this.metadata,
    this.time,
    this.type,
    this.agent,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final Map<String, dynamic>? time;
  final String? type;
  final String? agent;

  /// Разбирает JSON в [Object] типа SessionMessageAgentSwitched.
  factory SessionMessageAgentSwitched.fromJson(Map<String, Object?> json) {
    return SessionMessageAgentSwitched(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      time: (json['time'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      type: json['type'] as String?,
      agent: json['agent'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'time': time,
    'type': type,
    'agent': agent,
  };
}

class SessionMessageModelSwitched {
  /// Создаёт модель из полей.
  SessionMessageModelSwitched({
    this.id,
    this.metadata,
    this.time,
    this.type,
    this.model,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final Map<String, dynamic>? time;
  final String? type;
  final ModelRef? model;

  /// Разбирает JSON в [Object] типа SessionMessageModelSwitched.
  factory SessionMessageModelSwitched.fromJson(Map<String, Object?> json) {
    return SessionMessageModelSwitched(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      time: (json['time'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      type: json['type'] as String?,
      model: (json['model'] as Map<String, Object?>?) == null
          ? null
          : ModelRef.fromJson(json['model'] as Map<String, Object?>),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'time': time,
    'type': type,
    'model': model?.toJson(),
  };
}

class SessionMessageUser {
  /// Создаёт модель из полей.
  SessionMessageUser({
    this.id,
    this.metadata,
    this.time,
    this.text,
    this.files,
    this.agents,
    this.type,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final Map<String, dynamic>? time;
  final String? text;
  final List<PromptFileAttachment>? files;
  final List<PromptAgentAttachment>? agents;
  final String? type;

  /// Разбирает JSON в [Object] типа SessionMessageUser.
  factory SessionMessageUser.fromJson(Map<String, Object?> json) {
    return SessionMessageUser(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      time: (json['time'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      text: json['text'] as String?,
      files: (json['files'] as List?)
          ?.map((e) => PromptFileAttachment.fromJson(e as Map<String, Object?>))
          .toList(),
      agents: (json['agents'] as List?)
          ?.map(
            (e) => PromptAgentAttachment.fromJson(e as Map<String, Object?>),
          )
          .toList(),
      type: json['type'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'time': time,
    'text': text,
    'files': files?.map((e) => e.toJson()).toList(),
    'agents': agents?.map((e) => e.toJson()).toList(),
    'type': type,
  };
}

class SessionMessageSynthetic {
  /// Создаёт модель из полей.
  SessionMessageSynthetic({
    this.id,
    this.metadata,
    this.time,
    this.sessionID,
    this.text,
    this.type,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final Map<String, dynamic>? time;
  final String? sessionID;
  final String? text;
  final String? type;

  /// Разбирает JSON в [Object] типа SessionMessageSynthetic.
  factory SessionMessageSynthetic.fromJson(Map<String, Object?> json) {
    return SessionMessageSynthetic(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      time: (json['time'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      sessionID: json['sessionID'] as String?,
      text: json['text'] as String?,
      type: json['type'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'time': time,
    'sessionID': sessionID,
    'text': text,
    'type': type,
  };
}

class SessionMessageSystem {
  /// Создаёт модель из полей.
  SessionMessageSystem({
    this.id,
    this.metadata,
    this.time,
    this.type,
    this.text,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final Map<String, dynamic>? time;
  final String? type;
  final String? text;

  /// Разбирает JSON в [Object] типа SessionMessageSystem.
  factory SessionMessageSystem.fromJson(Map<String, Object?> json) {
    return SessionMessageSystem(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      time: (json['time'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      type: json['type'] as String?,
      text: json['text'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'time': time,
    'type': type,
    'text': text,
  };
}

class SessionMessageShell {
  /// Создаёт модель из полей.
  SessionMessageShell({
    this.id,
    this.metadata,
    this.time,
    this.type,
    this.callID,
    this.command,
    this.output,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final Map<String, dynamic>? time;
  final String? type;
  final String? callID;
  final String? command;
  final String? output;

  /// Разбирает JSON в [Object] типа SessionMessageShell.
  factory SessionMessageShell.fromJson(Map<String, Object?> json) {
    return SessionMessageShell(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      time: (json['time'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      type: json['type'] as String?,
      callID: json['callID'] as String?,
      command: json['command'] as String?,
      output: json['output'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'time': time,
    'type': type,
    'callID': callID,
    'command': command,
    'output': output,
  };
}

class SessionMessageAssistantText {
  /// Создаёт модель из полей.
  SessionMessageAssistantText({
    required this.type,
    required this.id,
    required this.text,
  });
  final String type;
  final String id;
  final String text;

  /// Разбирает JSON в [Object] типа SessionMessageAssistantText.
  factory SessionMessageAssistantText.fromJson(Map<String, Object?> json) {
    return SessionMessageAssistantText(
      type: json['type'] as String,
      id: json['id'] as String,
      text: json['text'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'type': type, 'id': id, 'text': text};
}

class SessionMessageAssistantReasoning {
  /// Создаёт модель из полей.
  SessionMessageAssistantReasoning({
    required this.type,
    required this.id,
    required this.text,
    this.providerMetadata,
    this.time,
  });
  final String type;
  final String id;
  final String text;
  final Map<String, dynamic>? providerMetadata;
  final Map<String, dynamic>? time;

  /// Разбирает JSON в [Object] типа SessionMessageAssistantReasoning.
  factory SessionMessageAssistantReasoning.fromJson(Map<String, Object?> json) {
    return SessionMessageAssistantReasoning(
      type: json['type'] as String,
      id: json['id'] as String,
      text: json['text'] as String,
      providerMetadata: (json['providerMetadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      time: (json['time'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'text': text,
    'providerMetadata': providerMetadata,
    'time': time,
  };
}

class SessionMessageToolStatePending {
  /// Создаёт модель из полей.
  SessionMessageToolStatePending({required this.status, required this.input});
  final String status;
  final String input;

  /// Разбирает JSON в [Object] типа SessionMessageToolStatePending.
  factory SessionMessageToolStatePending.fromJson(Map<String, Object?> json) {
    return SessionMessageToolStatePending(
      status: json['status'] as String,
      input: json['input'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'status': status, 'input': input};
}

class SessionMessageToolStateRunning {
  /// Создаёт модель из полей.
  SessionMessageToolStateRunning({
    required this.status,
    required this.input,
    required this.structured,
    required this.content,
  });
  final String status;
  final Map<String, dynamic> input;
  final Map<String, dynamic> structured;
  final List<dynamic> content;

  /// Разбирает JSON в [Object] типа SessionMessageToolStateRunning.
  factory SessionMessageToolStateRunning.fromJson(Map<String, Object?> json) {
    return SessionMessageToolStateRunning(
      status: json['status'] as String,
      input: (json['input'] as Map).map((k, v) => MapEntry(k as String, v)),
      structured: (json['structured'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
      content: (json['content'] as List).map((e) => e).toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'status': status,
    'input': input,
    'structured': structured,
    'content': content,
  };
}

class SessionMessageToolStateCompleted {
  /// Создаёт модель из полей.
  SessionMessageToolStateCompleted({
    required this.status,
    required this.input,
    this.attachments,
    required this.content,
    this.outputPaths,
    required this.structured,
    this.result,
  });
  final String status;
  final Map<String, dynamic> input;
  final List<PromptFileAttachment>? attachments;
  final List<dynamic> content;
  final List<String>? outputPaths;
  final Map<String, dynamic> structured;
  final dynamic result;

  /// Разбирает JSON в [Object] типа SessionMessageToolStateCompleted.
  factory SessionMessageToolStateCompleted.fromJson(Map<String, Object?> json) {
    return SessionMessageToolStateCompleted(
      status: json['status'] as String,
      input: (json['input'] as Map).map((k, v) => MapEntry(k as String, v)),
      attachments: (json['attachments'] as List?)
          ?.map((e) => PromptFileAttachment.fromJson(e as Map<String, Object?>))
          .toList(),
      content: (json['content'] as List).map((e) => e).toList(),
      outputPaths: (json['outputPaths'] as List?)
          ?.map((e) => e as String)
          .toList(),
      structured: (json['structured'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
      result: json['result'],
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'status': status,
    'input': input,
    'attachments': attachments?.map((e) => e.toJson()).toList(),
    'content': content,
    'outputPaths': outputPaths,
    'structured': structured,
    'result': result,
  };
}

class SessionMessageToolStateError {
  /// Создаёт модель из полей.
  SessionMessageToolStateError({
    required this.status,
    required this.input,
    required this.content,
    required this.structured,
    required this.error,
    this.result,
  });
  final String status;
  final Map<String, dynamic> input;
  final List<dynamic> content;
  final Map<String, dynamic> structured;
  final SessionErrorUnknown error;
  final dynamic result;

  /// Разбирает JSON в [Object] типа SessionMessageToolStateError.
  factory SessionMessageToolStateError.fromJson(Map<String, Object?> json) {
    return SessionMessageToolStateError(
      status: json['status'] as String,
      input: (json['input'] as Map).map((k, v) => MapEntry(k as String, v)),
      content: (json['content'] as List).map((e) => e).toList(),
      structured: (json['structured'] as Map).map(
        (k, v) => MapEntry(k as String, v),
      ),
      error: SessionErrorUnknown.fromJson(
        json['error'] as Map<String, Object?>,
      ),
      result: json['result'],
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'status': status,
    'input': input,
    'content': content,
    'structured': structured,
    'error': error?.toJson(),
    'result': result,
  };
}

class SessionMessageAssistantTool {
  /// Создаёт модель из полей.
  SessionMessageAssistantTool({
    required this.type,
    required this.id,
    required this.name,
    this.provider,
    required this.state,
    required this.time,
  });
  final String type;
  final String id;
  final String name;
  final Map<String, dynamic>? provider;
  final dynamic state;
  final Map<String, dynamic> time;

  /// Разбирает JSON в [Object] типа SessionMessageAssistantTool.
  factory SessionMessageAssistantTool.fromJson(Map<String, Object?> json) {
    return SessionMessageAssistantTool(
      type: json['type'] as String,
      id: json['id'] as String,
      name: json['name'] as String,
      provider: (json['provider'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      state: json['state'],
      time: (json['time'] as Map).map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'id': id,
    'name': name,
    'provider': provider,
    'state': state,
    'time': time,
  };
}

class SessionMessageAssistant {
  /// Создаёт модель из полей.
  SessionMessageAssistant({
    this.id,
    this.metadata,
    this.time,
    this.type,
    this.agent,
    this.model,
    this.content,
    this.snapshot,
    this.finish,
    this.cost,
    this.tokens,
    this.error,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final Map<String, dynamic>? time;
  final String? type;
  final String? agent;
  final ModelRef? model;
  final List<dynamic>? content;
  final Map<String, dynamic>? snapshot;
  final String? finish;
  final double? cost;
  final Map<String, dynamic>? tokens;
  final SessionErrorUnknown? error;

  /// Разбирает JSON в [Object] типа SessionMessageAssistant.
  factory SessionMessageAssistant.fromJson(Map<String, Object?> json) {
    return SessionMessageAssistant(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      time: (json['time'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      type: json['type'] as String?,
      agent: json['agent'] as String?,
      model: (json['model'] as Map<String, Object?>?) == null
          ? null
          : ModelRef.fromJson(json['model'] as Map<String, Object?>),
      content: (json['content'] as List?)?.cast<dynamic>(),
      snapshot: (json['snapshot'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      finish: json['finish'] as String?,
      cost: (json['cost'] as num?)?.toDouble(),
      tokens: (json['tokens'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      error: (json['error'] as Map<String, Object?>?) == null
          ? null
          : SessionErrorUnknown.fromJson(json['error'] as Map<String, Object?>),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'time': time,
    'type': type,
    'agent': agent,
    'model': model?.toJson(),
    'content': content,
    'snapshot': snapshot,
    'finish': finish,
    'cost': cost,
    'tokens': tokens,
    'error': error?.toJson(),
  };
}

class SessionMessageCompaction {
  /// Создаёт модель из полей.
  SessionMessageCompaction({
    this.type,
    this.reason,
    this.summary,
    this.recent,
    this.id,
    this.metadata,
    this.time,
  });
  final String? type;
  final String? reason;
  final String? summary;
  final String? recent;
  final String? id;
  final Map<String, dynamic>? metadata;
  final Map<String, dynamic>? time;

  /// Разбирает JSON в [Object] типа SessionMessageCompaction.
  factory SessionMessageCompaction.fromJson(Map<String, Object?> json) {
    return SessionMessageCompaction(
      type: json['type'] as String?,
      reason: json['reason'] as String?,
      summary: json['summary'] as String?,
      recent: json['recent'] as String?,
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      time: (json['time'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'reason': reason,
    'summary': summary,
    'recent': recent,
    'id': id,
    'metadata': metadata,
    'time': time,
  };
}

class SessionNextAgentSwitched {
  /// Создаёт модель из полей.
  SessionNextAgentSwitched({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextAgentSwitched.
  factory SessionNextAgentSwitched.fromJson(Map<String, Object?> json) {
    return SessionNextAgentSwitched(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextModelSwitched {
  /// Создаёт модель из полей.
  SessionNextModelSwitched({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextModelSwitched.
  factory SessionNextModelSwitched.fromJson(Map<String, Object?> json) {
    return SessionNextModelSwitched(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextMoved {
  /// Создаёт модель из полей.
  SessionNextMoved({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextMoved.
  factory SessionNextMoved.fromJson(Map<String, Object?> json) {
    return SessionNextMoved(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextPrompted {
  /// Создаёт модель из полей.
  SessionNextPrompted({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextPrompted.
  factory SessionNextPrompted.fromJson(Map<String, Object?> json) {
    return SessionNextPrompted(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextPromptAdmitted {
  /// Создаёт модель из полей.
  SessionNextPromptAdmitted({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextPromptAdmitted.
  factory SessionNextPromptAdmitted.fromJson(Map<String, Object?> json) {
    return SessionNextPromptAdmitted(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextContextUpdated {
  /// Создаёт модель из полей.
  SessionNextContextUpdated({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextContextUpdated.
  factory SessionNextContextUpdated.fromJson(Map<String, Object?> json) {
    return SessionNextContextUpdated(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextSynthetic {
  /// Создаёт модель из полей.
  SessionNextSynthetic({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextSynthetic.
  factory SessionNextSynthetic.fromJson(Map<String, Object?> json) {
    return SessionNextSynthetic(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextShellStarted {
  /// Создаёт модель из полей.
  SessionNextShellStarted({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextShellStarted.
  factory SessionNextShellStarted.fromJson(Map<String, Object?> json) {
    return SessionNextShellStarted(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextShellEnded {
  /// Создаёт модель из полей.
  SessionNextShellEnded({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextShellEnded.
  factory SessionNextShellEnded.fromJson(Map<String, Object?> json) {
    return SessionNextShellEnded(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextStepStarted {
  /// Создаёт модель из полей.
  SessionNextStepStarted({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextStepStarted.
  factory SessionNextStepStarted.fromJson(Map<String, Object?> json) {
    return SessionNextStepStarted(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextStepEnded {
  /// Создаёт модель из полей.
  SessionNextStepEnded({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextStepEnded.
  factory SessionNextStepEnded.fromJson(Map<String, Object?> json) {
    return SessionNextStepEnded(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextStepFailed {
  /// Создаёт модель из полей.
  SessionNextStepFailed({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextStepFailed.
  factory SessionNextStepFailed.fromJson(Map<String, Object?> json) {
    return SessionNextStepFailed(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextTextStarted {
  /// Создаёт модель из полей.
  SessionNextTextStarted({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextTextStarted.
  factory SessionNextTextStarted.fromJson(Map<String, Object?> json) {
    return SessionNextTextStarted(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextTextEnded {
  /// Создаёт модель из полей.
  SessionNextTextEnded({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextTextEnded.
  factory SessionNextTextEnded.fromJson(Map<String, Object?> json) {
    return SessionNextTextEnded(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextToolInputStarted {
  /// Создаёт модель из полей.
  SessionNextToolInputStarted({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextToolInputStarted.
  factory SessionNextToolInputStarted.fromJson(Map<String, Object?> json) {
    return SessionNextToolInputStarted(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextToolInputEnded {
  /// Создаёт модель из полей.
  SessionNextToolInputEnded({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextToolInputEnded.
  factory SessionNextToolInputEnded.fromJson(Map<String, Object?> json) {
    return SessionNextToolInputEnded(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextToolCalled {
  /// Создаёт модель из полей.
  SessionNextToolCalled({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextToolCalled.
  factory SessionNextToolCalled.fromJson(Map<String, Object?> json) {
    return SessionNextToolCalled(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextToolProgress {
  /// Создаёт модель из полей.
  SessionNextToolProgress({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextToolProgress.
  factory SessionNextToolProgress.fromJson(Map<String, Object?> json) {
    return SessionNextToolProgress(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextToolSuccess {
  /// Создаёт модель из полей.
  SessionNextToolSuccess({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextToolSuccess.
  factory SessionNextToolSuccess.fromJson(Map<String, Object?> json) {
    return SessionNextToolSuccess(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextToolFailed {
  /// Создаёт модель из полей.
  SessionNextToolFailed({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextToolFailed.
  factory SessionNextToolFailed.fromJson(Map<String, Object?> json) {
    return SessionNextToolFailed(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextReasoningStarted {
  /// Создаёт модель из полей.
  SessionNextReasoningStarted({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextReasoningStarted.
  factory SessionNextReasoningStarted.fromJson(Map<String, Object?> json) {
    return SessionNextReasoningStarted(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextReasoningEnded {
  /// Создаёт модель из полей.
  SessionNextReasoningEnded({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextReasoningEnded.
  factory SessionNextReasoningEnded.fromJson(Map<String, Object?> json) {
    return SessionNextReasoningEnded(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextRetried {
  /// Создаёт модель из полей.
  SessionNextRetried({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextRetried.
  factory SessionNextRetried.fromJson(Map<String, Object?> json) {
    return SessionNextRetried(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextCompactionStarted {
  /// Создаёт модель из полей.
  SessionNextCompactionStarted({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextCompactionStarted.
  factory SessionNextCompactionStarted.fromJson(Map<String, Object?> json) {
    return SessionNextCompactionStarted(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextCompactionEnded {
  /// Создаёт модель из полей.
  SessionNextCompactionEnded({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextCompactionEnded.
  factory SessionNextCompactionEnded.fromJson(Map<String, Object?> json) {
    return SessionNextCompactionEnded(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextRevertStaged {
  /// Создаёт модель из полей.
  SessionNextRevertStaged({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextRevertStaged.
  factory SessionNextRevertStaged.fromJson(Map<String, Object?> json) {
    return SessionNextRevertStaged(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextRevertCleared {
  /// Создаёт модель из полей.
  SessionNextRevertCleared({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextRevertCleared.
  factory SessionNextRevertCleared.fromJson(Map<String, Object?> json) {
    return SessionNextRevertCleared(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextRevertCommitted {
  /// Создаёт модель из полей.
  SessionNextRevertCommitted({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextRevertCommitted.
  factory SessionNextRevertCommitted.fromJson(Map<String, Object?> json) {
    return SessionNextRevertCommitted(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class ModelCapabilities {
  /// Создаёт модель из полей.
  ModelCapabilities({
    required this.tools,
    required this.input,
    required this.output,
  });
  final bool tools;
  final List<String> input;
  final List<String> output;

  /// Разбирает JSON в [Object] типа ModelCapabilities.
  factory ModelCapabilities.fromJson(Map<String, Object?> json) {
    return ModelCapabilities(
      tools: json['tools'] as bool,
      input: (json['input'] as List).map((e) => e as String).toList(),
      output: (json['output'] as List).map((e) => e as String).toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'tools': tools,
    'input': input,
    'output': output,
  };
}

class ModelCost {
  /// Создаёт модель из полей.
  ModelCost({
    this.tier,
    required this.input,
    required this.output,
    required this.cache,
  });
  final Map<String, dynamic>? tier;
  final double input;
  final double output;
  final Map<String, dynamic> cache;

  /// Разбирает JSON в [Object] типа ModelCost.
  factory ModelCost.fromJson(Map<String, Object?> json) {
    return ModelCost(
      tier: (json['tier'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
      input: (json['input'] as num).toDouble(),
      output: (json['output'] as num).toDouble(),
      cache: (json['cache'] as Map).map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'tier': tier,
    'input': input,
    'output': output,
    'cache': cache,
  };
}

class ModelV2Info {
  /// Создаёт модель из полей.
  ModelV2Info({
    required this.id,
    required this.providerID,
    this.family,
    required this.name,
    required this.api,
    required this.capabilities,
    required this.request,
    required this.variants,
    required this.time,
    required this.cost,
    required this.status,
    required this.enabled,
    required this.limit,
  });
  final String id;
  final String providerID;
  final String? family;
  final String name;
  final dynamic api;
  final ModelCapabilities capabilities;
  final Map<String, dynamic> request;
  final List<Map<String, dynamic>> variants;
  final Map<String, dynamic> time;
  final List<ModelCost> cost;
  final String status;
  final bool enabled;
  final Map<String, dynamic> limit;

  /// Разбирает JSON в [Object] типа ModelV2Info.
  factory ModelV2Info.fromJson(Map<String, Object?> json) {
    return ModelV2Info(
      id: json['id'] as String,
      providerID: json['providerID'] as String,
      family: json['family'] as String?,
      name: json['name'] as String,
      api: json['api'],
      capabilities: ModelCapabilities.fromJson(
        json['capabilities'] as Map<String, Object?>,
      ),
      request: (json['request'] as Map).map((k, v) => MapEntry(k as String, v)),
      variants: (json['variants'] as List)
          .map((e) => e as Map<String, Object?>)
          .toList(),
      time: (json['time'] as Map).map((k, v) => MapEntry(k as String, v)),
      cost: (json['cost'] as List)
          .map((e) => ModelCost.fromJson(e as Map<String, Object?>))
          .toList(),
      status: json['status'] as String,
      enabled: json['enabled'] as bool,
      limit: (json['limit'] as Map).map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'providerID': providerID,
    'family': family,
    'name': name,
    'api': api,
    'capabilities': capabilities?.toJson(),
    'request': request,
    'variants': variants,
    'time': time,
    'cost': cost?.map((e) => e.toJson()).toList(),
    'status': status,
    'enabled': enabled,
    'limit': limit,
  };
}

class ProviderAISDK {
  /// Создаёт модель из полей.
  ProviderAISDK({this.type, this.package, this.url, this.settings});
  final String? type;
  final String? package;
  final String? url;
  final Map<String, dynamic>? settings;

  /// Разбирает JSON в [Object] типа ProviderAISDK.
  factory ProviderAISDK.fromJson(Map<String, Object?> json) {
    return ProviderAISDK(
      type: json['type'] as String?,
      package: json['package'] as String?,
      url: json['url'] as String?,
      settings: (json['settings'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'package': package,
    'url': url,
    'settings': settings,
  };
}

class ProviderNative {
  /// Создаёт модель из полей.
  ProviderNative({this.type, this.url, this.settings});
  final String? type;
  final String? url;
  final Map<String, dynamic>? settings;

  /// Разбирает JSON в [Object] типа ProviderNative.
  factory ProviderNative.fromJson(Map<String, Object?> json) {
    return ProviderNative(
      type: json['type'] as String?,
      url: json['url'] as String?,
      settings: (json['settings'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'url': url,
    'settings': settings,
  };
}

class ProviderV2Info {
  /// Создаёт модель из полей.
  ProviderV2Info({
    required this.id,
    this.integrationID,
    required this.name,
    this.disabled,
    required this.api,
    required this.request,
  });
  final String id;
  final String? integrationID;
  final String name;
  final bool? disabled;
  final dynamic api;
  final ProviderRequest request;

  /// Разбирает JSON в [Object] типа ProviderV2Info.
  factory ProviderV2Info.fromJson(Map<String, Object?> json) {
    return ProviderV2Info(
      id: json['id'] as String,
      integrationID: json['integrationID'] as String?,
      name: json['name'] as String,
      disabled: json['disabled'] as bool?,
      api: json['api'],
      request: ProviderRequest.fromJson(
        json['request'] as Map<String, Object?>,
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'integrationID': integrationID,
    'name': name,
    'disabled': disabled,
    'api': api,
    'request': request?.toJson(),
  };
}

class IntegrationWhen {
  /// Создаёт модель из полей.
  IntegrationWhen({required this.key, required this.op, required this.value});
  final String key;
  final String op;
  final String value;

  /// Разбирает JSON в [Object] типа IntegrationWhen.
  factory IntegrationWhen.fromJson(Map<String, Object?> json) {
    return IntegrationWhen(
      key: json['key'] as String,
      op: json['op'] as String,
      value: json['value'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'key': key, 'op': op, 'value': value};
}

class IntegrationTextPrompt {
  /// Создаёт модель из полей.
  IntegrationTextPrompt({
    required this.type,
    required this.key,
    required this.message,
    this.placeholder,
    this.when_,
  });
  final String type;
  final String key;
  final String message;
  final String? placeholder;
  final IntegrationWhen? when_;

  /// Разбирает JSON в [Object] типа IntegrationTextPrompt.
  factory IntegrationTextPrompt.fromJson(Map<String, Object?> json) {
    return IntegrationTextPrompt(
      type: json['type'] as String,
      key: json['key'] as String,
      message: json['message'] as String,
      placeholder: json['placeholder'] as String?,
      when_: (json['when'] as Map<String, Object?>?) == null
          ? null
          : IntegrationWhen.fromJson(json['when'] as Map<String, Object?>),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'key': key,
    'message': message,
    'placeholder': placeholder,
    'when': when_?.toJson(),
  };
}

class IntegrationSelectPrompt {
  /// Создаёт модель из полей.
  IntegrationSelectPrompt({
    required this.type,
    required this.key,
    required this.message,
    required this.options,
    this.when_,
  });
  final String type;
  final String key;
  final String message;
  final List<Map<String, dynamic>> options;
  final IntegrationWhen? when_;

  /// Разбирает JSON в [Object] типа IntegrationSelectPrompt.
  factory IntegrationSelectPrompt.fromJson(Map<String, Object?> json) {
    return IntegrationSelectPrompt(
      type: json['type'] as String,
      key: json['key'] as String,
      message: json['message'] as String,
      options: (json['options'] as List)
          .map((e) => e as Map<String, Object?>)
          .toList(),
      when_: (json['when'] as Map<String, Object?>?) == null
          ? null
          : IntegrationWhen.fromJson(json['when'] as Map<String, Object?>),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'key': key,
    'message': message,
    'options': options,
    'when': when_?.toJson(),
  };
}

class IntegrationOAuthMethod {
  /// Создаёт модель из полей.
  IntegrationOAuthMethod({this.id, this.type, this.label, this.prompts});
  final String? id;
  final String? type;
  final String? label;
  final List<dynamic>? prompts;

  /// Разбирает JSON в [Object] типа IntegrationOAuthMethod.
  factory IntegrationOAuthMethod.fromJson(Map<String, Object?> json) {
    return IntegrationOAuthMethod(
      id: json['id'] as String?,
      type: json['type'] as String?,
      label: json['label'] as String?,
      prompts: (json['prompts'] as List?)?.cast<dynamic>(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'label': label,
    'prompts': prompts,
  };
}

class IntegrationKeyMethod {
  /// Создаёт модель из полей.
  IntegrationKeyMethod({this.type, this.label});
  final String? type;
  final String? label;

  /// Разбирает JSON в [Object] типа IntegrationKeyMethod.
  factory IntegrationKeyMethod.fromJson(Map<String, Object?> json) {
    return IntegrationKeyMethod(
      type: json['type'] as String?,
      label: json['label'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'type': type, 'label': label};
}

class IntegrationEnvMethod {
  /// Создаёт модель из полей.
  IntegrationEnvMethod({this.type, this.names});
  final String? type;
  final List<String>? names;

  /// Разбирает JSON в [Object] типа IntegrationEnvMethod.
  factory IntegrationEnvMethod.fromJson(Map<String, Object?> json) {
    return IntegrationEnvMethod(
      type: json['type'] as String?,
      names: (json['names'] as List?)?.map((e) => e as String).toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'type': type, 'names': names};
}

class ConnectionCredentialInfo {
  /// Создаёт модель из полей.
  ConnectionCredentialInfo({this.type, this.id, this.label});
  final String? type;
  final String? id;
  final String? label;

  /// Разбирает JSON в [Object] типа ConnectionCredentialInfo.
  factory ConnectionCredentialInfo.fromJson(Map<String, Object?> json) {
    return ConnectionCredentialInfo(
      type: json['type'] as String?,
      id: json['id'] as String?,
      label: json['label'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'type': type, 'id': id, 'label': label};
}

class ConnectionEnvInfo {
  /// Создаёт модель из полей.
  ConnectionEnvInfo({this.type, this.name});
  final String? type;
  final String? name;

  /// Разбирает JSON в [Object] типа ConnectionEnvInfo.
  factory ConnectionEnvInfo.fromJson(Map<String, Object?> json) {
    return ConnectionEnvInfo(
      type: json['type'] as String?,
      name: json['name'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'type': type, 'name': name};
}

class IntegrationInfo {
  /// Создаёт модель из полей.
  IntegrationInfo({
    required this.id,
    required this.name,
    required this.methods,
    required this.connections,
  });
  final String id;
  final String name;
  final List<dynamic> methods;
  final List<dynamic> connections;

  /// Разбирает JSON в [Object] типа IntegrationInfo.
  factory IntegrationInfo.fromJson(Map<String, Object?> json) {
    return IntegrationInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      methods: (json['methods'] as List).map((e) => e).toList(),
      connections: (json['connections'] as List).map((e) => e).toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'methods': methods,
    'connections': connections,
  };
}

class IntegrationAttempt {
  /// Создаёт модель из полей.
  IntegrationAttempt({
    required this.attemptID,
    required this.url,
    required this.instructions,
    required this.mode,
    required this.time,
  });
  final String attemptID;
  final String url;
  final String instructions;
  final String mode;
  final Map<String, dynamic> time;

  /// Разбирает JSON в [Object] типа IntegrationAttempt.
  factory IntegrationAttempt.fromJson(Map<String, Object?> json) {
    return IntegrationAttempt(
      attemptID: json['attemptID'] as String,
      url: json['url'] as String,
      instructions: json['instructions'] as String,
      mode: json['mode'] as String,
      time: (json['time'] as Map).map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'attemptID': attemptID,
    'url': url,
    'instructions': instructions,
    'mode': mode,
    'time': time,
  };
}

class PermissionV2Request {
  /// Создаёт модель из полей.
  PermissionV2Request({
    required this.id,
    required this.sessionID,
    required this.action,
    required this.resources,
    this.save,
    this.metadata,
    this.source,
  });
  final String id;
  final String sessionID;
  final String action;
  final List<String> resources;
  final List<String>? save;
  final Map<String, dynamic>? metadata;
  final PermissionV2Source? source;

  /// Разбирает JSON в [Object] типа PermissionV2Request.
  factory PermissionV2Request.fromJson(Map<String, Object?> json) {
    return PermissionV2Request(
      id: json['id'] as String,
      sessionID: json['sessionID'] as String,
      action: json['action'] as String,
      resources: (json['resources'] as List).map((e) => e as String).toList(),
      save: (json['save'] as List?)?.map((e) => e as String).toList(),
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      source: (json['source'] as Map<String, Object?>?) == null
          ? null
          : PermissionV2Source.fromJson(json['source'] as Map<String, Object?>),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'sessionID': sessionID,
    'action': action,
    'resources': resources,
    'save': save,
    'metadata': metadata,
    'source': source?.toJson(),
  };
}

class PermissionSavedInfo {
  /// Создаёт модель из полей.
  PermissionSavedInfo({
    required this.id,
    required this.projectID,
    required this.action,
    required this.resource,
  });
  final String id;
  final String projectID;
  final String action;
  final String resource;

  /// Разбирает JSON в [Object] типа PermissionSavedInfo.
  factory PermissionSavedInfo.fromJson(Map<String, Object?> json) {
    return PermissionSavedInfo(
      id: json['id'] as String,
      projectID: json['projectID'] as String,
      action: json['action'] as String,
      resource: json['resource'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'projectID': projectID,
    'action': action,
    'resource': resource,
  };
}

class FileSystemEntry {
  /// Создаёт модель из полей.
  FileSystemEntry({required this.path, required this.type});
  final String path;
  final String type;

  /// Разбирает JSON в [Object] типа FileSystemEntry.
  factory FileSystemEntry.fromJson(Map<String, Object?> json) {
    return FileSystemEntry(
      path: json['path'] as String,
      type: json['type'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'path': path, 'type': type};
}

class CommandV2Info {
  /// Создаёт модель из полей.
  CommandV2Info({
    required this.name,
    required this.template,
    this.description,
    this.agent,
    this.model,
    this.subtask,
  });
  final String name;
  final String template;
  final String? description;
  final String? agent;
  final ModelRef? model;
  final bool? subtask;

  /// Разбирает JSON в [Object] типа CommandV2Info.
  factory CommandV2Info.fromJson(Map<String, Object?> json) {
    return CommandV2Info(
      name: json['name'] as String,
      template: json['template'] as String,
      description: json['description'] as String?,
      agent: json['agent'] as String?,
      model: (json['model'] as Map<String, Object?>?) == null
          ? null
          : ModelRef.fromJson(json['model'] as Map<String, Object?>),
      subtask: json['subtask'] as bool?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'name': name,
    'template': template,
    'description': description,
    'agent': agent,
    'model': model?.toJson(),
    'subtask': subtask,
  };
}

class SkillV2Info {
  /// Создаёт модель из полей.
  SkillV2Info({
    required this.name,
    this.description,
    this.slash,
    required this.location,
    required this.content,
  });
  final String name;
  final String? description;
  final bool? slash;
  final String location;
  final String content;

  /// Разбирает JSON в [Object] типа SkillV2Info.
  factory SkillV2Info.fromJson(Map<String, Object?> json) {
    return SkillV2Info(
      name: json['name'] as String,
      description: json['description'] as String?,
      slash: json['slash'] as bool?,
      location: json['location'] as String,
      content: json['content'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'name': name,
    'description': description,
    'slash': slash,
    'location': location,
    'content': content,
  };
}

class ModelsDevRefreshed {
  /// Создаёт модель из полей.
  ModelsDevRefreshed({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа ModelsDevRefreshed.
  factory ModelsDevRefreshed.fromJson(Map<String, Object?> json) {
    return ModelsDevRefreshed(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class IntegrationUpdated {
  /// Создаёт модель из полей.
  IntegrationUpdated({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа IntegrationUpdated.
  factory IntegrationUpdated.fromJson(Map<String, Object?> json) {
    return IntegrationUpdated(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class IntegrationConnectionUpdated {
  /// Создаёт модель из полей.
  IntegrationConnectionUpdated({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа IntegrationConnectionUpdated.
  factory IntegrationConnectionUpdated.fromJson(Map<String, Object?> json) {
    return IntegrationConnectionUpdated(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class CatalogUpdated {
  /// Создаёт модель из полей.
  CatalogUpdated({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа CatalogUpdated.
  factory CatalogUpdated.fromJson(Map<String, Object?> json) {
    return CatalogUpdated(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionCreated {
  /// Создаёт модель из полей.
  SessionCreated({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionCreated.
  factory SessionCreated.fromJson(Map<String, Object?> json) {
    return SessionCreated(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionUpdated {
  /// Создаёт модель из полей.
  SessionUpdated({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionUpdated.
  factory SessionUpdated.fromJson(Map<String, Object?> json) {
    return SessionUpdated(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionDeleted {
  /// Создаёт модель из полей.
  SessionDeleted({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionDeleted.
  factory SessionDeleted.fromJson(Map<String, Object?> json) {
    return SessionDeleted(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class MessageUpdated {
  /// Создаёт модель из полей.
  MessageUpdated({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа MessageUpdated.
  factory MessageUpdated.fromJson(Map<String, Object?> json) {
    return MessageUpdated(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class MessageRemoved {
  /// Создаёт модель из полей.
  MessageRemoved({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа MessageRemoved.
  factory MessageRemoved.fromJson(Map<String, Object?> json) {
    return MessageRemoved(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class MessagePartUpdated {
  /// Создаёт модель из полей.
  MessagePartUpdated({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа MessagePartUpdated.
  factory MessagePartUpdated.fromJson(Map<String, Object?> json) {
    return MessagePartUpdated(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class MessagePartRemoved {
  /// Создаёт модель из полей.
  MessagePartRemoved({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа MessagePartRemoved.
  factory MessagePartRemoved.fromJson(Map<String, Object?> json) {
    return MessagePartRemoved(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextTextDelta {
  /// Создаёт модель из полей.
  SessionNextTextDelta({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextTextDelta.
  factory SessionNextTextDelta.fromJson(Map<String, Object?> json) {
    return SessionNextTextDelta(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextReasoningDelta {
  /// Создаёт модель из полей.
  SessionNextReasoningDelta({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextReasoningDelta.
  factory SessionNextReasoningDelta.fromJson(Map<String, Object?> json) {
    return SessionNextReasoningDelta(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextToolInputDelta {
  /// Создаёт модель из полей.
  SessionNextToolInputDelta({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextToolInputDelta.
  factory SessionNextToolInputDelta.fromJson(Map<String, Object?> json) {
    return SessionNextToolInputDelta(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionNextCompactionDelta {
  /// Создаёт модель из полей.
  SessionNextCompactionDelta({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionNextCompactionDelta.
  factory SessionNextCompactionDelta.fromJson(Map<String, Object?> json) {
    return SessionNextCompactionDelta(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class MessagePartDelta {
  /// Создаёт модель из полей.
  MessagePartDelta({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа MessagePartDelta.
  factory MessagePartDelta.fromJson(Map<String, Object?> json) {
    return MessagePartDelta(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionDiff {
  /// Создаёт модель из полей.
  SessionDiff({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionDiff.
  factory SessionDiff.fromJson(Map<String, Object?> json) {
    return SessionDiff(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionError {
  /// Создаёт модель из полей.
  SessionError({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionError.
  factory SessionError.fromJson(Map<String, Object?> json) {
    return SessionError(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class InstallationUpdated {
  /// Создаёт модель из полей.
  InstallationUpdated({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа InstallationUpdated.
  factory InstallationUpdated.fromJson(Map<String, Object?> json) {
    return InstallationUpdated(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class InstallationUpdateAvailable {
  /// Создаёт модель из полей.
  InstallationUpdateAvailable({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа InstallationUpdateAvailable.
  factory InstallationUpdateAvailable.fromJson(Map<String, Object?> json) {
    return InstallationUpdateAvailable(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class FileEdited {
  /// Создаёт модель из полей.
  FileEdited({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа FileEdited.
  factory FileEdited.fromJson(Map<String, Object?> json) {
    return FileEdited(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class ReferenceUpdated {
  /// Создаёт модель из полей.
  ReferenceUpdated({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа ReferenceUpdated.
  factory ReferenceUpdated.fromJson(Map<String, Object?> json) {
    return ReferenceUpdated(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class PermissionV2Asked {
  /// Создаёт модель из полей.
  PermissionV2Asked({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа PermissionV2Asked.
  factory PermissionV2Asked.fromJson(Map<String, Object?> json) {
    return PermissionV2Asked(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class PermissionV2Replied {
  /// Создаёт модель из полей.
  PermissionV2Replied({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа PermissionV2Replied.
  factory PermissionV2Replied.fromJson(Map<String, Object?> json) {
    return PermissionV2Replied(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class PluginAdded {
  /// Создаёт модель из полей.
  PluginAdded({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа PluginAdded.
  factory PluginAdded.fromJson(Map<String, Object?> json) {
    return PluginAdded(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class ProjectDirectoriesUpdated {
  /// Создаёт модель из полей.
  ProjectDirectoriesUpdated({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа ProjectDirectoriesUpdated.
  factory ProjectDirectoriesUpdated.fromJson(Map<String, Object?> json) {
    return ProjectDirectoriesUpdated(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class FileWatcherUpdated {
  /// Создаёт модель из полей.
  FileWatcherUpdated({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа FileWatcherUpdated.
  factory FileWatcherUpdated.fromJson(Map<String, Object?> json) {
    return FileWatcherUpdated(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class PtyCreated {
  /// Создаёт модель из полей.
  PtyCreated({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа PtyCreated.
  factory PtyCreated.fromJson(Map<String, Object?> json) {
    return PtyCreated(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class PtyUpdated {
  /// Создаёт модель из полей.
  PtyUpdated({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа PtyUpdated.
  factory PtyUpdated.fromJson(Map<String, Object?> json) {
    return PtyUpdated(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class PtyExited {
  /// Создаёт модель из полей.
  PtyExited({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа PtyExited.
  factory PtyExited.fromJson(Map<String, Object?> json) {
    return PtyExited(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class PtyDeleted {
  /// Создаёт модель из полей.
  PtyDeleted({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа PtyDeleted.
  factory PtyDeleted.fromJson(Map<String, Object?> json) {
    return PtyDeleted(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class QuestionV2Asked {
  /// Создаёт модель из полей.
  QuestionV2Asked({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа QuestionV2Asked.
  factory QuestionV2Asked.fromJson(Map<String, Object?> json) {
    return QuestionV2Asked(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class QuestionV2Replied {
  /// Создаёт модель из полей.
  QuestionV2Replied({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа QuestionV2Replied.
  factory QuestionV2Replied.fromJson(Map<String, Object?> json) {
    return QuestionV2Replied(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class QuestionV2Rejected {
  /// Создаёт модель из полей.
  QuestionV2Rejected({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа QuestionV2Rejected.
  factory QuestionV2Rejected.fromJson(Map<String, Object?> json) {
    return QuestionV2Rejected(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class TodoUpdated {
  /// Создаёт модель из полей.
  TodoUpdated({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа TodoUpdated.
  factory TodoUpdated.fromJson(Map<String, Object?> json) {
    return TodoUpdated(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class LspUpdated {
  /// Создаёт модель из полей.
  LspUpdated({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа LspUpdated.
  factory LspUpdated.fromJson(Map<String, Object?> json) {
    return LspUpdated(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class PermissionAsked {
  /// Создаёт модель из полей.
  PermissionAsked({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа PermissionAsked.
  factory PermissionAsked.fromJson(Map<String, Object?> json) {
    return PermissionAsked(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class PermissionReplied {
  /// Создаёт модель из полей.
  PermissionReplied({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа PermissionReplied.
  factory PermissionReplied.fromJson(Map<String, Object?> json) {
    return PermissionReplied(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class TuiPromptAppend {
  /// Создаёт модель из полей.
  TuiPromptAppend({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа TuiPromptAppend.
  factory TuiPromptAppend.fromJson(Map<String, Object?> json) {
    return TuiPromptAppend(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class TuiCommandExecute {
  /// Создаёт модель из полей.
  TuiCommandExecute({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа TuiCommandExecute.
  factory TuiCommandExecute.fromJson(Map<String, Object?> json) {
    return TuiCommandExecute(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class TuiToastShow {
  /// Создаёт модель из полей.
  TuiToastShow({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа TuiToastShow.
  factory TuiToastShow.fromJson(Map<String, Object?> json) {
    return TuiToastShow(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class TuiSessionSelect {
  /// Создаёт модель из полей.
  TuiSessionSelect({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа TuiSessionSelect.
  factory TuiSessionSelect.fromJson(Map<String, Object?> json) {
    return TuiSessionSelect(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class McpToolsChanged {
  /// Создаёт модель из полей.
  McpToolsChanged({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа McpToolsChanged.
  factory McpToolsChanged.fromJson(Map<String, Object?> json) {
    return McpToolsChanged(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class McpBrowserOpenFailed {
  /// Создаёт модель из полей.
  McpBrowserOpenFailed({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа McpBrowserOpenFailed.
  factory McpBrowserOpenFailed.fromJson(Map<String, Object?> json) {
    return McpBrowserOpenFailed(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class CommandExecuted {
  /// Создаёт модель из полей.
  CommandExecuted({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа CommandExecuted.
  factory CommandExecuted.fromJson(Map<String, Object?> json) {
    return CommandExecuted(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class ProjectUpdated {
  /// Создаёт модель из полей.
  ProjectUpdated({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа ProjectUpdated.
  factory ProjectUpdated.fromJson(Map<String, Object?> json) {
    return ProjectUpdated(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionIdle {
  /// Создаёт модель из полей.
  SessionIdle({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionIdle.
  factory SessionIdle.fromJson(Map<String, Object?> json) {
    return SessionIdle(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class QuestionAsked {
  /// Создаёт модель из полей.
  QuestionAsked({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа QuestionAsked.
  factory QuestionAsked.fromJson(Map<String, Object?> json) {
    return QuestionAsked(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class SessionCompacted {
  /// Создаёт модель из полей.
  SessionCompacted({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа SessionCompacted.
  factory SessionCompacted.fromJson(Map<String, Object?> json) {
    return SessionCompacted(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class VcsBranchUpdated {
  /// Создаёт модель из полей.
  VcsBranchUpdated({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа VcsBranchUpdated.
  factory VcsBranchUpdated.fromJson(Map<String, Object?> json) {
    return VcsBranchUpdated(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class WorkspaceReady {
  /// Создаёт модель из полей.
  WorkspaceReady({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа WorkspaceReady.
  factory WorkspaceReady.fromJson(Map<String, Object?> json) {
    return WorkspaceReady(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class WorkspaceFailed {
  /// Создаёт модель из полей.
  WorkspaceFailed({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа WorkspaceFailed.
  factory WorkspaceFailed.fromJson(Map<String, Object?> json) {
    return WorkspaceFailed(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class WorkspaceStatus {
  /// Создаёт модель из полей.
  WorkspaceStatus({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа WorkspaceStatus.
  factory WorkspaceStatus.fromJson(Map<String, Object?> json) {
    return WorkspaceStatus(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class WorktreeReady {
  /// Создаёт модель из полей.
  WorktreeReady({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа WorktreeReady.
  factory WorktreeReady.fromJson(Map<String, Object?> json) {
    return WorktreeReady(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class WorktreeFailed {
  /// Создаёт модель из полей.
  WorktreeFailed({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа WorktreeFailed.
  factory WorktreeFailed.fromJson(Map<String, Object?> json) {
    return WorktreeFailed(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class ServerConnected {
  /// Создаёт модель из полей.
  ServerConnected({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа ServerConnected.
  factory ServerConnected.fromJson(Map<String, Object?> json) {
    return ServerConnected(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class GlobalDisposed {
  /// Создаёт модель из полей.
  GlobalDisposed({
    this.id,
    this.metadata,
    this.type,
    this.durable,
    this.location,
    this.data,
  });
  final String? id;
  final Map<String, dynamic>? metadata;
  final String? type;
  final Map<String, dynamic>? durable;
  final LocationRef? location;
  final Map<String, dynamic>? data;

  /// Разбирает JSON в [Object] типа GlobalDisposed.
  factory GlobalDisposed.fromJson(Map<String, Object?> json) {
    return GlobalDisposed(
      id: json['id'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      type: json['type'] as String?,
      durable: (json['durable'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
      location: (json['location'] as Map<String, Object?>?) == null
          ? null
          : LocationRef.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as Map?)?.map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'metadata': metadata,
    'type': type,
    'durable': durable,
    'location': location?.toJson(),
    'data': data,
  };
}

class QuestionV2Request {
  /// Создаёт модель из полей.
  QuestionV2Request({
    required this.id,
    required this.sessionID,
    required this.questions,
    this.tool,
  });
  final String id;
  final String sessionID;
  final List<QuestionV2Info> questions;
  final QuestionV2Tool? tool;

  /// Разбирает JSON в [Object] типа QuestionV2Request.
  factory QuestionV2Request.fromJson(Map<String, Object?> json) {
    return QuestionV2Request(
      id: json['id'] as String,
      sessionID: json['sessionID'] as String,
      questions: (json['questions'] as List)
          .map((e) => QuestionV2Info.fromJson(e as Map<String, Object?>))
          .toList(),
      tool: (json['tool'] as Map<String, Object?>?) == null
          ? null
          : QuestionV2Tool.fromJson(json['tool'] as Map<String, Object?>),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'sessionID': sessionID,
    'questions': questions?.map((e) => e.toJson()).toList(),
    'tool': tool?.toJson(),
  };
}

class QuestionV2Reply {
  /// Создаёт модель из полей.
  QuestionV2Reply({required this.answers});
  final List<String> answers;

  /// Разбирает JSON в [Object] типа QuestionV2Reply.
  factory QuestionV2Reply.fromJson(Map<String, Object?> json) {
    return QuestionV2Reply(
      answers: (json['answers'] as List).map((e) => e as String).toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'answers': answers};
}

class ReferenceLocalSource {
  /// Создаёт модель из полей.
  ReferenceLocalSource({this.type, this.path, this.description, this.hidden});
  final String? type;
  final String? path;
  final String? description;
  final bool? hidden;

  /// Разбирает JSON в [Object] типа ReferenceLocalSource.
  factory ReferenceLocalSource.fromJson(Map<String, Object?> json) {
    return ReferenceLocalSource(
      type: json['type'] as String?,
      path: json['path'] as String?,
      description: json['description'] as String?,
      hidden: json['hidden'] as bool?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'path': path,
    'description': description,
    'hidden': hidden,
  };
}

class ReferenceGitSource {
  /// Создаёт модель из полей.
  ReferenceGitSource({
    this.type,
    this.repository,
    this.branch,
    this.description,
    this.hidden,
  });
  final String? type;
  final String? repository;
  final String? branch;
  final String? description;
  final bool? hidden;

  /// Разбирает JSON в [Object] типа ReferenceGitSource.
  factory ReferenceGitSource.fromJson(Map<String, Object?> json) {
    return ReferenceGitSource(
      type: json['type'] as String?,
      repository: json['repository'] as String?,
      branch: json['branch'] as String?,
      description: json['description'] as String?,
      hidden: json['hidden'] as bool?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'repository': repository,
    'branch': branch,
    'description': description,
    'hidden': hidden,
  };
}

class ReferenceInfo {
  /// Создаёт модель из полей.
  ReferenceInfo({
    required this.name,
    required this.path,
    this.description,
    this.hidden,
    required this.source,
  });
  final String name;
  final String path;
  final String? description;
  final bool? hidden;
  final dynamic source;

  /// Разбирает JSON в [Object] типа ReferenceInfo.
  factory ReferenceInfo.fromJson(Map<String, Object?> json) {
    return ReferenceInfo(
      name: json['name'] as String,
      path: json['path'] as String,
      description: json['description'] as String?,
      hidden: json['hidden'] as bool?,
      source: json['source'],
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'name': name,
    'path': path,
    'description': description,
    'hidden': hidden,
    'source': source,
  };
}

class ProjectCopyCopy {
  /// Создаёт модель из полей.
  ProjectCopyCopy({required this.directory});
  final String directory;

  /// Разбирает JSON в [Object] типа ProjectCopyCopy.
  factory ProjectCopyCopy.fromJson(Map<String, Object?> json) {
    return ProjectCopyCopy(directory: json['directory'] as String);
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'directory': directory};
}

class EventModelsDevRefreshed {
  /// Создаёт модель из полей.
  EventModelsDevRefreshed({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventModelsDevRefreshed.
  factory EventModelsDevRefreshed.fromJson(Map<String, Object?> json) {
    return EventModelsDevRefreshed(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventIntegrationUpdated {
  /// Создаёт модель из полей.
  EventIntegrationUpdated({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventIntegrationUpdated.
  factory EventIntegrationUpdated.fromJson(Map<String, Object?> json) {
    return EventIntegrationUpdated(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventIntegrationConnectionUpdated {
  /// Создаёт модель из полей.
  EventIntegrationConnectionUpdated({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventIntegrationConnectionUpdated.
  factory EventIntegrationConnectionUpdated.fromJson(
    Map<String, Object?> json,
  ) {
    return EventIntegrationConnectionUpdated(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventCatalogUpdated {
  /// Создаёт модель из полей.
  EventCatalogUpdated({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventCatalogUpdated.
  factory EventCatalogUpdated.fromJson(Map<String, Object?> json) {
    return EventCatalogUpdated(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionCreated {
  /// Создаёт модель из полей.
  EventSessionCreated({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionCreated.
  factory EventSessionCreated.fromJson(Map<String, Object?> json) {
    return EventSessionCreated(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionUpdated {
  /// Создаёт модель из полей.
  EventSessionUpdated({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionUpdated.
  factory EventSessionUpdated.fromJson(Map<String, Object?> json) {
    return EventSessionUpdated(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionDeleted {
  /// Создаёт модель из полей.
  EventSessionDeleted({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionDeleted.
  factory EventSessionDeleted.fromJson(Map<String, Object?> json) {
    return EventSessionDeleted(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventMessageUpdated {
  /// Создаёт модель из полей.
  EventMessageUpdated({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventMessageUpdated.
  factory EventMessageUpdated.fromJson(Map<String, Object?> json) {
    return EventMessageUpdated(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventMessageRemoved {
  /// Создаёт модель из полей.
  EventMessageRemoved({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventMessageRemoved.
  factory EventMessageRemoved.fromJson(Map<String, Object?> json) {
    return EventMessageRemoved(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventMessagePartUpdated {
  /// Создаёт модель из полей.
  EventMessagePartUpdated({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventMessagePartUpdated.
  factory EventMessagePartUpdated.fromJson(Map<String, Object?> json) {
    return EventMessagePartUpdated(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventMessagePartRemoved {
  /// Создаёт модель из полей.
  EventMessagePartRemoved({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventMessagePartRemoved.
  factory EventMessagePartRemoved.fromJson(Map<String, Object?> json) {
    return EventMessagePartRemoved(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextAgentSwitched {
  /// Создаёт модель из полей.
  EventSessionNextAgentSwitched({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextAgentSwitched.
  factory EventSessionNextAgentSwitched.fromJson(Map<String, Object?> json) {
    return EventSessionNextAgentSwitched(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextModelSwitched {
  /// Создаёт модель из полей.
  EventSessionNextModelSwitched({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextModelSwitched.
  factory EventSessionNextModelSwitched.fromJson(Map<String, Object?> json) {
    return EventSessionNextModelSwitched(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextMoved {
  /// Создаёт модель из полей.
  EventSessionNextMoved({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextMoved.
  factory EventSessionNextMoved.fromJson(Map<String, Object?> json) {
    return EventSessionNextMoved(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextPrompted {
  /// Создаёт модель из полей.
  EventSessionNextPrompted({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextPrompted.
  factory EventSessionNextPrompted.fromJson(Map<String, Object?> json) {
    return EventSessionNextPrompted(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextPromptAdmitted {
  /// Создаёт модель из полей.
  EventSessionNextPromptAdmitted({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextPromptAdmitted.
  factory EventSessionNextPromptAdmitted.fromJson(Map<String, Object?> json) {
    return EventSessionNextPromptAdmitted(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextContextUpdated {
  /// Создаёт модель из полей.
  EventSessionNextContextUpdated({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextContextUpdated.
  factory EventSessionNextContextUpdated.fromJson(Map<String, Object?> json) {
    return EventSessionNextContextUpdated(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextSynthetic {
  /// Создаёт модель из полей.
  EventSessionNextSynthetic({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextSynthetic.
  factory EventSessionNextSynthetic.fromJson(Map<String, Object?> json) {
    return EventSessionNextSynthetic(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextShellStarted {
  /// Создаёт модель из полей.
  EventSessionNextShellStarted({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextShellStarted.
  factory EventSessionNextShellStarted.fromJson(Map<String, Object?> json) {
    return EventSessionNextShellStarted(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextShellEnded {
  /// Создаёт модель из полей.
  EventSessionNextShellEnded({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextShellEnded.
  factory EventSessionNextShellEnded.fromJson(Map<String, Object?> json) {
    return EventSessionNextShellEnded(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextStepStarted {
  /// Создаёт модель из полей.
  EventSessionNextStepStarted({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextStepStarted.
  factory EventSessionNextStepStarted.fromJson(Map<String, Object?> json) {
    return EventSessionNextStepStarted(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextStepEnded {
  /// Создаёт модель из полей.
  EventSessionNextStepEnded({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextStepEnded.
  factory EventSessionNextStepEnded.fromJson(Map<String, Object?> json) {
    return EventSessionNextStepEnded(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextStepFailed {
  /// Создаёт модель из полей.
  EventSessionNextStepFailed({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextStepFailed.
  factory EventSessionNextStepFailed.fromJson(Map<String, Object?> json) {
    return EventSessionNextStepFailed(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextTextStarted {
  /// Создаёт модель из полей.
  EventSessionNextTextStarted({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextTextStarted.
  factory EventSessionNextTextStarted.fromJson(Map<String, Object?> json) {
    return EventSessionNextTextStarted(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextTextDelta {
  /// Создаёт модель из полей.
  EventSessionNextTextDelta({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextTextDelta.
  factory EventSessionNextTextDelta.fromJson(Map<String, Object?> json) {
    return EventSessionNextTextDelta(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextTextEnded {
  /// Создаёт модель из полей.
  EventSessionNextTextEnded({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextTextEnded.
  factory EventSessionNextTextEnded.fromJson(Map<String, Object?> json) {
    return EventSessionNextTextEnded(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextReasoningStarted {
  /// Создаёт модель из полей.
  EventSessionNextReasoningStarted({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextReasoningStarted.
  factory EventSessionNextReasoningStarted.fromJson(Map<String, Object?> json) {
    return EventSessionNextReasoningStarted(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextReasoningDelta {
  /// Создаёт модель из полей.
  EventSessionNextReasoningDelta({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextReasoningDelta.
  factory EventSessionNextReasoningDelta.fromJson(Map<String, Object?> json) {
    return EventSessionNextReasoningDelta(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextReasoningEnded {
  /// Создаёт модель из полей.
  EventSessionNextReasoningEnded({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextReasoningEnded.
  factory EventSessionNextReasoningEnded.fromJson(Map<String, Object?> json) {
    return EventSessionNextReasoningEnded(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextToolInputStarted {
  /// Создаёт модель из полей.
  EventSessionNextToolInputStarted({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextToolInputStarted.
  factory EventSessionNextToolInputStarted.fromJson(Map<String, Object?> json) {
    return EventSessionNextToolInputStarted(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextToolInputDelta {
  /// Создаёт модель из полей.
  EventSessionNextToolInputDelta({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextToolInputDelta.
  factory EventSessionNextToolInputDelta.fromJson(Map<String, Object?> json) {
    return EventSessionNextToolInputDelta(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextToolInputEnded {
  /// Создаёт модель из полей.
  EventSessionNextToolInputEnded({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextToolInputEnded.
  factory EventSessionNextToolInputEnded.fromJson(Map<String, Object?> json) {
    return EventSessionNextToolInputEnded(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextToolCalled {
  /// Создаёт модель из полей.
  EventSessionNextToolCalled({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextToolCalled.
  factory EventSessionNextToolCalled.fromJson(Map<String, Object?> json) {
    return EventSessionNextToolCalled(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextToolProgress {
  /// Создаёт модель из полей.
  EventSessionNextToolProgress({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextToolProgress.
  factory EventSessionNextToolProgress.fromJson(Map<String, Object?> json) {
    return EventSessionNextToolProgress(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextToolSuccess {
  /// Создаёт модель из полей.
  EventSessionNextToolSuccess({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextToolSuccess.
  factory EventSessionNextToolSuccess.fromJson(Map<String, Object?> json) {
    return EventSessionNextToolSuccess(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextToolFailed {
  /// Создаёт модель из полей.
  EventSessionNextToolFailed({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextToolFailed.
  factory EventSessionNextToolFailed.fromJson(Map<String, Object?> json) {
    return EventSessionNextToolFailed(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextRetried {
  /// Создаёт модель из полей.
  EventSessionNextRetried({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextRetried.
  factory EventSessionNextRetried.fromJson(Map<String, Object?> json) {
    return EventSessionNextRetried(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextCompactionStarted {
  /// Создаёт модель из полей.
  EventSessionNextCompactionStarted({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextCompactionStarted.
  factory EventSessionNextCompactionStarted.fromJson(
    Map<String, Object?> json,
  ) {
    return EventSessionNextCompactionStarted(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextCompactionDelta {
  /// Создаёт модель из полей.
  EventSessionNextCompactionDelta({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextCompactionDelta.
  factory EventSessionNextCompactionDelta.fromJson(Map<String, Object?> json) {
    return EventSessionNextCompactionDelta(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextCompactionEnded {
  /// Создаёт модель из полей.
  EventSessionNextCompactionEnded({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextCompactionEnded.
  factory EventSessionNextCompactionEnded.fromJson(Map<String, Object?> json) {
    return EventSessionNextCompactionEnded(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextRevertStaged {
  /// Создаёт модель из полей.
  EventSessionNextRevertStaged({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextRevertStaged.
  factory EventSessionNextRevertStaged.fromJson(Map<String, Object?> json) {
    return EventSessionNextRevertStaged(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextRevertCleared {
  /// Создаёт модель из полей.
  EventSessionNextRevertCleared({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextRevertCleared.
  factory EventSessionNextRevertCleared.fromJson(Map<String, Object?> json) {
    return EventSessionNextRevertCleared(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionNextRevertCommitted {
  /// Создаёт модель из полей.
  EventSessionNextRevertCommitted({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionNextRevertCommitted.
  factory EventSessionNextRevertCommitted.fromJson(Map<String, Object?> json) {
    return EventSessionNextRevertCommitted(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventMessagePartDelta {
  /// Создаёт модель из полей.
  EventMessagePartDelta({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventMessagePartDelta.
  factory EventMessagePartDelta.fromJson(Map<String, Object?> json) {
    return EventMessagePartDelta(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionDiff {
  /// Создаёт модель из полей.
  EventSessionDiff({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionDiff.
  factory EventSessionDiff.fromJson(Map<String, Object?> json) {
    return EventSessionDiff(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionError {
  /// Создаёт модель из полей.
  EventSessionError({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionError.
  factory EventSessionError.fromJson(Map<String, Object?> json) {
    return EventSessionError(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventInstallationUpdated {
  /// Создаёт модель из полей.
  EventInstallationUpdated({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventInstallationUpdated.
  factory EventInstallationUpdated.fromJson(Map<String, Object?> json) {
    return EventInstallationUpdated(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventInstallationUpdateAvailable {
  /// Создаёт модель из полей.
  EventInstallationUpdateAvailable({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventInstallationUpdateAvailable.
  factory EventInstallationUpdateAvailable.fromJson(Map<String, Object?> json) {
    return EventInstallationUpdateAvailable(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventFileEdited {
  /// Создаёт модель из полей.
  EventFileEdited({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventFileEdited.
  factory EventFileEdited.fromJson(Map<String, Object?> json) {
    return EventFileEdited(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventReferenceUpdated {
  /// Создаёт модель из полей.
  EventReferenceUpdated({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventReferenceUpdated.
  factory EventReferenceUpdated.fromJson(Map<String, Object?> json) {
    return EventReferenceUpdated(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventPermissionV2Asked {
  /// Создаёт модель из полей.
  EventPermissionV2Asked({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventPermissionV2Asked.
  factory EventPermissionV2Asked.fromJson(Map<String, Object?> json) {
    return EventPermissionV2Asked(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventPermissionV2Replied {
  /// Создаёт модель из полей.
  EventPermissionV2Replied({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventPermissionV2Replied.
  factory EventPermissionV2Replied.fromJson(Map<String, Object?> json) {
    return EventPermissionV2Replied(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventPluginAdded {
  /// Создаёт модель из полей.
  EventPluginAdded({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventPluginAdded.
  factory EventPluginAdded.fromJson(Map<String, Object?> json) {
    return EventPluginAdded(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventProjectDirectoriesUpdated {
  /// Создаёт модель из полей.
  EventProjectDirectoriesUpdated({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventProjectDirectoriesUpdated.
  factory EventProjectDirectoriesUpdated.fromJson(Map<String, Object?> json) {
    return EventProjectDirectoriesUpdated(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventFileWatcherUpdated {
  /// Создаёт модель из полей.
  EventFileWatcherUpdated({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventFileWatcherUpdated.
  factory EventFileWatcherUpdated.fromJson(Map<String, Object?> json) {
    return EventFileWatcherUpdated(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventPtyCreated {
  /// Создаёт модель из полей.
  EventPtyCreated({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventPtyCreated.
  factory EventPtyCreated.fromJson(Map<String, Object?> json) {
    return EventPtyCreated(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventPtyUpdated {
  /// Создаёт модель из полей.
  EventPtyUpdated({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventPtyUpdated.
  factory EventPtyUpdated.fromJson(Map<String, Object?> json) {
    return EventPtyUpdated(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventPtyExited {
  /// Создаёт модель из полей.
  EventPtyExited({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventPtyExited.
  factory EventPtyExited.fromJson(Map<String, Object?> json) {
    return EventPtyExited(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventPtyDeleted {
  /// Создаёт модель из полей.
  EventPtyDeleted({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventPtyDeleted.
  factory EventPtyDeleted.fromJson(Map<String, Object?> json) {
    return EventPtyDeleted(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventQuestionV2Asked {
  /// Создаёт модель из полей.
  EventQuestionV2Asked({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventQuestionV2Asked.
  factory EventQuestionV2Asked.fromJson(Map<String, Object?> json) {
    return EventQuestionV2Asked(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventQuestionV2Replied {
  /// Создаёт модель из полей.
  EventQuestionV2Replied({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventQuestionV2Replied.
  factory EventQuestionV2Replied.fromJson(Map<String, Object?> json) {
    return EventQuestionV2Replied(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventQuestionV2Rejected {
  /// Создаёт модель из полей.
  EventQuestionV2Rejected({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventQuestionV2Rejected.
  factory EventQuestionV2Rejected.fromJson(Map<String, Object?> json) {
    return EventQuestionV2Rejected(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventTodoUpdated {
  /// Создаёт модель из полей.
  EventTodoUpdated({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventTodoUpdated.
  factory EventTodoUpdated.fromJson(Map<String, Object?> json) {
    return EventTodoUpdated(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventLspUpdated {
  /// Создаёт модель из полей.
  EventLspUpdated({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventLspUpdated.
  factory EventLspUpdated.fromJson(Map<String, Object?> json) {
    return EventLspUpdated(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventPermissionAsked {
  /// Создаёт модель из полей.
  EventPermissionAsked({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventPermissionAsked.
  factory EventPermissionAsked.fromJson(Map<String, Object?> json) {
    return EventPermissionAsked(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventPermissionReplied {
  /// Создаёт модель из полей.
  EventPermissionReplied({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventPermissionReplied.
  factory EventPermissionReplied.fromJson(Map<String, Object?> json) {
    return EventPermissionReplied(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventMcpToolsChanged {
  /// Создаёт модель из полей.
  EventMcpToolsChanged({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventMcpToolsChanged.
  factory EventMcpToolsChanged.fromJson(Map<String, Object?> json) {
    return EventMcpToolsChanged(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventMcpBrowserOpenFailed {
  /// Создаёт модель из полей.
  EventMcpBrowserOpenFailed({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventMcpBrowserOpenFailed.
  factory EventMcpBrowserOpenFailed.fromJson(Map<String, Object?> json) {
    return EventMcpBrowserOpenFailed(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventCommandExecuted {
  /// Создаёт модель из полей.
  EventCommandExecuted({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventCommandExecuted.
  factory EventCommandExecuted.fromJson(Map<String, Object?> json) {
    return EventCommandExecuted(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventProjectUpdated {
  /// Создаёт модель из полей.
  EventProjectUpdated({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventProjectUpdated.
  factory EventProjectUpdated.fromJson(Map<String, Object?> json) {
    return EventProjectUpdated(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionStatus {
  /// Создаёт модель из полей.
  EventSessionStatus({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionStatus.
  factory EventSessionStatus.fromJson(Map<String, Object?> json) {
    return EventSessionStatus(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionIdle {
  /// Создаёт модель из полей.
  EventSessionIdle({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionIdle.
  factory EventSessionIdle.fromJson(Map<String, Object?> json) {
    return EventSessionIdle(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventQuestionAsked {
  /// Создаёт модель из полей.
  EventQuestionAsked({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventQuestionAsked.
  factory EventQuestionAsked.fromJson(Map<String, Object?> json) {
    return EventQuestionAsked(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventQuestionReplied {
  /// Создаёт модель из полей.
  EventQuestionReplied({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventQuestionReplied.
  factory EventQuestionReplied.fromJson(Map<String, Object?> json) {
    return EventQuestionReplied(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventQuestionRejected {
  /// Создаёт модель из полей.
  EventQuestionRejected({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventQuestionRejected.
  factory EventQuestionRejected.fromJson(Map<String, Object?> json) {
    return EventQuestionRejected(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventSessionCompacted {
  /// Создаёт модель из полей.
  EventSessionCompacted({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventSessionCompacted.
  factory EventSessionCompacted.fromJson(Map<String, Object?> json) {
    return EventSessionCompacted(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventVcsBranchUpdated {
  /// Создаёт модель из полей.
  EventVcsBranchUpdated({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventVcsBranchUpdated.
  factory EventVcsBranchUpdated.fromJson(Map<String, Object?> json) {
    return EventVcsBranchUpdated(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventWorkspaceReady {
  /// Создаёт модель из полей.
  EventWorkspaceReady({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventWorkspaceReady.
  factory EventWorkspaceReady.fromJson(Map<String, Object?> json) {
    return EventWorkspaceReady(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventWorkspaceFailed {
  /// Создаёт модель из полей.
  EventWorkspaceFailed({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventWorkspaceFailed.
  factory EventWorkspaceFailed.fromJson(Map<String, Object?> json) {
    return EventWorkspaceFailed(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventWorkspaceStatus {
  /// Создаёт модель из полей.
  EventWorkspaceStatus({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventWorkspaceStatus.
  factory EventWorkspaceStatus.fromJson(Map<String, Object?> json) {
    return EventWorkspaceStatus(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventWorktreeReady {
  /// Создаёт модель из полей.
  EventWorktreeReady({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventWorktreeReady.
  factory EventWorktreeReady.fromJson(Map<String, Object?> json) {
    return EventWorktreeReady(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventWorktreeFailed {
  /// Создаёт модель из полей.
  EventWorktreeFailed({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventWorktreeFailed.
  factory EventWorktreeFailed.fromJson(Map<String, Object?> json) {
    return EventWorktreeFailed(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventServerConnected {
  /// Создаёт модель из полей.
  EventServerConnected({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventServerConnected.
  factory EventServerConnected.fromJson(Map<String, Object?> json) {
    return EventServerConnected(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class EventGlobalDisposed {
  /// Создаёт модель из полей.
  EventGlobalDisposed({this.id, this.type, this.properties});
  final String? id;
  final String? type;
  final Map<String, dynamic>? properties;

  /// Разбирает JSON в [Object] типа EventGlobalDisposed.
  factory EventGlobalDisposed.fromJson(Map<String, Object?> json) {
    return EventGlobalDisposed(
      id: json['id'] as String?,
      type: json['type'] as String?,
      properties: (json['properties'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type,
    'properties': properties,
  };
}

class CredentialOAuth {
  /// Создаёт модель из полей.
  CredentialOAuth({
    this.type,
    this.methodID,
    this.refresh,
    this.access,
    this.expires,
    this.metadata,
  });
  final String? type;
  final String? methodID;
  final String? refresh;
  final String? access;
  final int? expires;
  final Map<String, dynamic>? metadata;

  /// Разбирает JSON в [Object] типа CredentialOAuth.
  factory CredentialOAuth.fromJson(Map<String, Object?> json) {
    return CredentialOAuth(
      type: json['type'] as String?,
      methodID: json['methodID'] as String?,
      refresh: json['refresh'] as String?,
      access: json['access'] as String?,
      expires: (json['expires'] as num?)?.toInt(),
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'methodID': methodID,
    'refresh': refresh,
    'access': access,
    'expires': expires,
    'metadata': metadata,
  };
}

class CredentialKey {
  /// Создаёт модель из полей.
  CredentialKey({this.type, this.key, this.metadata});
  final String? type;
  final String? key;
  final Map<String, dynamic>? metadata;

  /// Разбирает JSON в [Object] типа CredentialKey.
  factory CredentialKey.fromJson(Map<String, Object?> json) {
    return CredentialKey(
      type: json['type'] as String?,
      key: json['key'] as String?,
      metadata: (json['metadata'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'type': type,
    'key': key,
    'metadata': metadata,
  };
}

class SkillV2DirectorySource {
  /// Создаёт модель из полей.
  SkillV2DirectorySource({this.type, this.path});
  final String? type;
  final String? path;

  /// Разбирает JSON в [Object] типа SkillV2DirectorySource.
  factory SkillV2DirectorySource.fromJson(Map<String, Object?> json) {
    return SkillV2DirectorySource(
      type: json['type'] as String?,
      path: json['path'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'type': type, 'path': path};
}

class SkillV2UrlSource {
  /// Создаёт модель из полей.
  SkillV2UrlSource({this.type, this.url});
  final String? type;
  final String? url;

  /// Разбирает JSON в [Object] типа SkillV2UrlSource.
  factory SkillV2UrlSource.fromJson(Map<String, Object?> json) {
    return SkillV2UrlSource(
      type: json['type'] as String?,
      url: json['url'] as String?,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'type': type, 'url': url};
}

class SkillV2EmbeddedSource {
  /// Создаёт модель из полей.
  SkillV2EmbeddedSource({this.type, this.skill});
  final String? type;
  final SkillV2Info? skill;

  /// Разбирает JSON в [Object] типа SkillV2EmbeddedSource.
  factory SkillV2EmbeddedSource.fromJson(Map<String, Object?> json) {
    return SkillV2EmbeddedSource(
      type: json['type'] as String?,
      skill: (json['skill'] as Map<String, Object?>?) == null
          ? null
          : SkillV2Info.fromJson(json['skill'] as Map<String, Object?>),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'type': type, 'skill': skill?.toJson()};
}

class BadRequestError {
  /// Создаёт модель из полей.
  BadRequestError({required this.name, required this.data});
  final String name;
  final Map<String, dynamic> data;

  /// Разбирает JSON в [Object] типа BadRequestError.
  factory BadRequestError.fromJson(Map<String, Object?> json) {
    return BadRequestError(
      name: json['name'] as String,
      data: (json['data'] as Map).map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'name': name, 'data': data};
}

class GlobalHealthResponse {
  /// Создаёт модель из полей.
  GlobalHealthResponse({required this.healthy, required this.version});
  final bool healthy;
  final String version;

  /// Разбирает JSON в [Object] типа GlobalHealthResponse.
  factory GlobalHealthResponse.fromJson(Map<String, Object?> json) {
    return GlobalHealthResponse(
      healthy: json['healthy'] as bool,
      version: json['version'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'healthy': healthy, 'version': version};
}

class ConfigProvidersResponse {
  /// Создаёт модель из полей.
  ConfigProvidersResponse({required this.providers, required this.default_});
  final List<Provider> providers;
  final Map<String, String> default_;

  /// Разбирает JSON в [Object] типа ConfigProvidersResponse.
  factory ConfigProvidersResponse.fromJson(Map<String, Object?> json) {
    return ConfigProvidersResponse(
      providers: (json['providers'] as List)
          .map((e) => Provider.fromJson(e as Map<String, Object?>))
          .toList(),
      default_: (json['default'] as Map).map(
        (k, v) => MapEntry(k as String, v as String),
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'providers': providers?.map((e) => e.toJson()).toList(),
    'default': default_,
  };
}

class ExperimentalConsoleListOrgsResponse {
  /// Создаёт модель из полей.
  ExperimentalConsoleListOrgsResponse({required this.orgs});
  final List<Map<String, dynamic>> orgs;

  /// Разбирает JSON в [Object] типа ExperimentalConsoleListOrgsResponse.
  factory ExperimentalConsoleListOrgsResponse.fromJson(
    Map<String, Object?> json,
  ) {
    return ExperimentalConsoleListOrgsResponse(
      orgs: (json['orgs'] as List)
          .map((e) => e as Map<String, Object?>)
          .toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'orgs': orgs};
}

class ExperimentalResourceListResponse {
  /// Создаёт модель из полей.
  ExperimentalResourceListResponse();

  /// Разбирает JSON в [Object] типа ExperimentalResourceListResponse.
  factory ExperimentalResourceListResponse.fromJson(Map<String, Object?> json) {
    return ExperimentalResourceListResponse();
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {};
}

class VcsApplyResponse {
  /// Создаёт модель из полей.
  VcsApplyResponse({required this.applied});
  final bool applied;

  /// Разбирает JSON в [Object] типа VcsApplyResponse.
  factory VcsApplyResponse.fromJson(Map<String, Object?> json) {
    return VcsApplyResponse(applied: json['applied'] as bool);
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'applied': applied};
}

class McpStatusResponse {
  /// Создаёт модель из полей.
  McpStatusResponse();

  /// Разбирает JSON в [Object] типа McpStatusResponse.
  factory McpStatusResponse.fromJson(Map<String, Object?> json) {
    return McpStatusResponse();
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {};
}

class McpAddResponse {
  /// Создаёт модель из полей.
  McpAddResponse();

  /// Разбирает JSON в [Object] типа McpAddResponse.
  factory McpAddResponse.fromJson(Map<String, Object?> json) {
    return McpAddResponse();
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {};
}

class McpAuthStartResponse {
  /// Создаёт модель из полей.
  McpAuthStartResponse({
    required this.authorizationUrl,
    required this.oauthState,
  });
  final String authorizationUrl;
  final String oauthState;

  /// Разбирает JSON в [Object] типа McpAuthStartResponse.
  factory McpAuthStartResponse.fromJson(Map<String, Object?> json) {
    return McpAuthStartResponse(
      authorizationUrl: json['authorizationUrl'] as String,
      oauthState: json['oauthState'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'authorizationUrl': authorizationUrl,
    'oauthState': oauthState,
  };
}

class McpAuthRemoveResponse {
  /// Создаёт модель из полей.
  McpAuthRemoveResponse({required this.success});
  final bool success;

  /// Разбирает JSON в [Object] типа McpAuthRemoveResponse.
  factory McpAuthRemoveResponse.fromJson(Map<String, Object?> json) {
    return McpAuthRemoveResponse(success: json['success'] as bool);
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'success': success};
}

class ExperimentalProjectCopyGenerateNameResponse {
  /// Создаёт модель из полей.
  ExperimentalProjectCopyGenerateNameResponse({required this.name});
  final String name;

  /// Разбирает JSON в [Object] типа ExperimentalProjectCopyGenerateNameResponse.
  factory ExperimentalProjectCopyGenerateNameResponse.fromJson(
    Map<String, Object?> json,
  ) {
    return ExperimentalProjectCopyGenerateNameResponse(
      name: json['name'] as String,
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'name': name};
}

class ProviderListResponse {
  /// Создаёт модель из полей.
  ProviderListResponse({
    required this.all,
    required this.default_,
    required this.connected,
  });
  final List<Provider> all;
  final Map<String, String> default_;
  final List<String> connected;

  /// Разбирает JSON в [Object] типа ProviderListResponse.
  factory ProviderListResponse.fromJson(Map<String, Object?> json) {
    return ProviderListResponse(
      all: (json['all'] as List)
          .map((e) => Provider.fromJson(e as Map<String, Object?>))
          .toList(),
      default_: (json['default'] as Map).map(
        (k, v) => MapEntry(k as String, v as String),
      ),
      connected: (json['connected'] as List).map((e) => e as String).toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'all': all?.map((e) => e.toJson()).toList(),
    'default': default_,
    'connected': connected,
  };
}

class ProviderAuthResponse {
  /// Создаёт модель из полей.
  ProviderAuthResponse();

  /// Разбирает JSON в [Object] типа ProviderAuthResponse.
  factory ProviderAuthResponse.fromJson(Map<String, Object?> json) {
    return ProviderAuthResponse();
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {};
}

class SessionStatusResponse {
  /// Создаёт модель из полей.
  SessionStatusResponse();

  /// Разбирает JSON в [Object] типа SessionStatusResponse.
  factory SessionStatusResponse.fromJson(Map<String, Object?> json) {
    return SessionStatusResponse();
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {};
}

class SessionPromptResponse {
  /// Создаёт модель из полей.
  SessionPromptResponse({required this.info, required this.parts});
  final AssistantMessage info;
  final List<dynamic> parts;

  /// Разбирает JSON в [Object] типа SessionPromptResponse.
  factory SessionPromptResponse.fromJson(Map<String, Object?> json) {
    return SessionPromptResponse(
      info: AssistantMessage.fromJson(json['info'] as Map<String, Object?>),
      parts: (json['parts'] as List).map((e) => e).toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'info': info?.toJson(), 'parts': parts};
}

class SessionMessageResponse {
  /// Создаёт модель из полей.
  SessionMessageResponse({required this.info, required this.parts});
  final dynamic info;
  final List<dynamic> parts;

  /// Разбирает JSON в [Object] типа SessionMessageResponse.
  factory SessionMessageResponse.fromJson(Map<String, Object?> json) {
    return SessionMessageResponse(
      info: json['info'],
      parts: (json['parts'] as List).map((e) => e).toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'info': info, 'parts': parts};
}

class SessionCommandResponse {
  /// Создаёт модель из полей.
  SessionCommandResponse({required this.info, required this.parts});
  final AssistantMessage info;
  final List<dynamic> parts;

  /// Разбирает JSON в [Object] типа SessionCommandResponse.
  factory SessionCommandResponse.fromJson(Map<String, Object?> json) {
    return SessionCommandResponse(
      info: AssistantMessage.fromJson(json['info'] as Map<String, Object?>),
      parts: (json['parts'] as List).map((e) => e).toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'info': info?.toJson(), 'parts': parts};
}

class SessionShellResponse {
  /// Создаёт модель из полей.
  SessionShellResponse({required this.info, required this.parts});
  final dynamic info;
  final List<dynamic> parts;

  /// Разбирает JSON в [Object] типа SessionShellResponse.
  factory SessionShellResponse.fromJson(Map<String, Object?> json) {
    return SessionShellResponse(
      info: json['info'],
      parts: (json['parts'] as List).map((e) => e).toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'info': info, 'parts': parts};
}

class SyncReplayResponse {
  /// Создаёт модель из полей.
  SyncReplayResponse({required this.sessionID});
  final String sessionID;

  /// Разбирает JSON в [Object] типа SyncReplayResponse.
  factory SyncReplayResponse.fromJson(Map<String, Object?> json) {
    return SyncReplayResponse(sessionID: json['sessionID'] as String);
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'sessionID': sessionID};
}

class SyncStealResponse {
  /// Создаёт модель из полей.
  SyncStealResponse({required this.sessionID});
  final String sessionID;

  /// Разбирает JSON в [Object] типа SyncStealResponse.
  factory SyncStealResponse.fromJson(Map<String, Object?> json) {
    return SyncStealResponse(sessionID: json['sessionID'] as String);
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'sessionID': sessionID};
}

class TuiControlNextResponse {
  /// Создаёт модель из полей.
  TuiControlNextResponse({required this.path, required this.body});
  final String path;
  final dynamic body;

  /// Разбирает JSON в [Object] типа TuiControlNextResponse.
  factory TuiControlNextResponse.fromJson(Map<String, Object?> json) {
    return TuiControlNextResponse(
      path: json['path'] as String,
      body: json['body'],
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'path': path, 'body': body};
}

class V2HealthGetResponse {
  /// Создаёт модель из полей.
  V2HealthGetResponse({required this.healthy});
  final bool healthy;

  /// Разбирает JSON в [Object] типа V2HealthGetResponse.
  factory V2HealthGetResponse.fromJson(Map<String, Object?> json) {
    return V2HealthGetResponse(healthy: json['healthy'] as bool);
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'healthy': healthy};
}

class V2AgentListResponse {
  /// Создаёт модель из полей.
  V2AgentListResponse({required this.location, required this.data});
  final LocationInfo location;
  final List<AgentV2Info> data;

  /// Разбирает JSON в [Object] типа V2AgentListResponse.
  factory V2AgentListResponse.fromJson(Map<String, Object?> json) {
    return V2AgentListResponse(
      location: LocationInfo.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as List)
          .map((e) => AgentV2Info.fromJson(e as Map<String, Object?>))
          .toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'location': location?.toJson(),
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class V2SessionCreateResponse {
  /// Создаёт модель из полей.
  V2SessionCreateResponse({required this.data});
  final SessionV2Info data;

  /// Разбирает JSON в [Object] типа V2SessionCreateResponse.
  factory V2SessionCreateResponse.fromJson(Map<String, Object?> json) {
    return V2SessionCreateResponse(
      data: SessionV2Info.fromJson(json['data'] as Map<String, Object?>),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'data': data?.toJson()};
}

class V2SessionActiveResponse {
  /// Создаёт модель из полей.
  V2SessionActiveResponse({required this.data});
  final Map<String, dynamic> data;

  /// Разбирает JSON в [Object] типа V2SessionActiveResponse.
  factory V2SessionActiveResponse.fromJson(Map<String, Object?> json) {
    return V2SessionActiveResponse(
      data: (json['data'] as Map).map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'data': data};
}

class V2SessionGetResponse {
  /// Создаёт модель из полей.
  V2SessionGetResponse({required this.data});
  final SessionV2Info data;

  /// Разбирает JSON в [Object] типа V2SessionGetResponse.
  factory V2SessionGetResponse.fromJson(Map<String, Object?> json) {
    return V2SessionGetResponse(
      data: SessionV2Info.fromJson(json['data'] as Map<String, Object?>),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'data': data?.toJson()};
}

class V2SessionPromptResponse {
  /// Создаёт модель из полей.
  V2SessionPromptResponse({required this.data});
  final SessionInputAdmitted data;

  /// Разбирает JSON в [Object] типа V2SessionPromptResponse.
  factory V2SessionPromptResponse.fromJson(Map<String, Object?> json) {
    return V2SessionPromptResponse(
      data: SessionInputAdmitted.fromJson(json['data'] as Map<String, Object?>),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'data': data?.toJson()};
}

class V2SessionRevertStageResponse {
  /// Создаёт модель из полей.
  V2SessionRevertStageResponse({required this.data});
  final RevertState data;

  /// Разбирает JSON в [Object] типа V2SessionRevertStageResponse.
  factory V2SessionRevertStageResponse.fromJson(Map<String, Object?> json) {
    return V2SessionRevertStageResponse(
      data: RevertState.fromJson(json['data'] as Map<String, Object?>),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'data': data?.toJson()};
}

class V2SessionContextResponse {
  /// Создаёт модель из полей.
  V2SessionContextResponse({required this.data});
  final List<dynamic> data;

  /// Разбирает JSON в [Object] типа V2SessionContextResponse.
  factory V2SessionContextResponse.fromJson(Map<String, Object?> json) {
    return V2SessionContextResponse(
      data: (json['data'] as List).map((e) => e).toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'data': data};
}

class V2SessionMessageResponse {
  /// Создаёт модель из полей.
  V2SessionMessageResponse({required this.data});
  final dynamic data;

  /// Разбирает JSON в [Object] типа V2SessionMessageResponse.
  factory V2SessionMessageResponse.fromJson(Map<String, Object?> json) {
    return V2SessionMessageResponse(data: json['data']);
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'data': data};
}

class V2ModelListResponse {
  /// Создаёт модель из полей.
  V2ModelListResponse({required this.location, required this.data});
  final LocationInfo location;
  final List<ModelV2Info> data;

  /// Разбирает JSON в [Object] типа V2ModelListResponse.
  factory V2ModelListResponse.fromJson(Map<String, Object?> json) {
    return V2ModelListResponse(
      location: LocationInfo.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as List)
          .map((e) => ModelV2Info.fromJson(e as Map<String, Object?>))
          .toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'location': location?.toJson(),
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class V2ProviderListResponse {
  /// Создаёт модель из полей.
  V2ProviderListResponse({required this.location, required this.data});
  final LocationInfo location;
  final List<ProviderV2Info> data;

  /// Разбирает JSON в [Object] типа V2ProviderListResponse.
  factory V2ProviderListResponse.fromJson(Map<String, Object?> json) {
    return V2ProviderListResponse(
      location: LocationInfo.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as List)
          .map((e) => ProviderV2Info.fromJson(e as Map<String, Object?>))
          .toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'location': location?.toJson(),
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class V2ProviderGetResponse {
  /// Создаёт модель из полей.
  V2ProviderGetResponse({required this.location, required this.data});
  final LocationInfo location;
  final ProviderV2Info data;

  /// Разбирает JSON в [Object] типа V2ProviderGetResponse.
  factory V2ProviderGetResponse.fromJson(Map<String, Object?> json) {
    return V2ProviderGetResponse(
      location: LocationInfo.fromJson(json['location'] as Map<String, Object?>),
      data: ProviderV2Info.fromJson(json['data'] as Map<String, Object?>),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'location': location?.toJson(),
    'data': data?.toJson(),
  };
}

class V2IntegrationListResponse {
  /// Создаёт модель из полей.
  V2IntegrationListResponse({required this.location, required this.data});
  final LocationInfo location;
  final List<IntegrationInfo> data;

  /// Разбирает JSON в [Object] типа V2IntegrationListResponse.
  factory V2IntegrationListResponse.fromJson(Map<String, Object?> json) {
    return V2IntegrationListResponse(
      location: LocationInfo.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as List)
          .map((e) => IntegrationInfo.fromJson(e as Map<String, Object?>))
          .toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'location': location?.toJson(),
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class V2IntegrationGetResponse {
  /// Создаёт модель из полей.
  V2IntegrationGetResponse({required this.location, required this.data});
  final LocationInfo location;
  final IntegrationInfo data;

  /// Разбирает JSON в [Object] типа V2IntegrationGetResponse.
  factory V2IntegrationGetResponse.fromJson(Map<String, Object?> json) {
    return V2IntegrationGetResponse(
      location: LocationInfo.fromJson(json['location'] as Map<String, Object?>),
      data: IntegrationInfo.fromJson(json['data'] as Map<String, Object?>),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'location': location?.toJson(),
    'data': data?.toJson(),
  };
}

class V2IntegrationConnectOauthResponse {
  /// Создаёт модель из полей.
  V2IntegrationConnectOauthResponse({
    required this.location,
    required this.data,
  });
  final LocationInfo location;
  final IntegrationAttempt data;

  /// Разбирает JSON в [Object] типа V2IntegrationConnectOauthResponse.
  factory V2IntegrationConnectOauthResponse.fromJson(
    Map<String, Object?> json,
  ) {
    return V2IntegrationConnectOauthResponse(
      location: LocationInfo.fromJson(json['location'] as Map<String, Object?>),
      data: IntegrationAttempt.fromJson(json['data'] as Map<String, Object?>),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'location': location?.toJson(),
    'data': data?.toJson(),
  };
}

class V2IntegrationAttemptStatusResponse {
  /// Создаёт модель из полей.
  V2IntegrationAttemptStatusResponse({
    required this.location,
    required this.data,
  });
  final LocationInfo location;
  final dynamic data;

  /// Разбирает JSON в [Object] типа V2IntegrationAttemptStatusResponse.
  factory V2IntegrationAttemptStatusResponse.fromJson(
    Map<String, Object?> json,
  ) {
    return V2IntegrationAttemptStatusResponse(
      location: LocationInfo.fromJson(json['location'] as Map<String, Object?>),
      data: json['data'],
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'location': location?.toJson(),
    'data': data,
  };
}

class V2PermissionRequestListResponse {
  /// Создаёт модель из полей.
  V2PermissionRequestListResponse({required this.location, required this.data});
  final LocationInfo location;
  final List<PermissionV2Request> data;

  /// Разбирает JSON в [Object] типа V2PermissionRequestListResponse.
  factory V2PermissionRequestListResponse.fromJson(Map<String, Object?> json) {
    return V2PermissionRequestListResponse(
      location: LocationInfo.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as List)
          .map((e) => PermissionV2Request.fromJson(e as Map<String, Object?>))
          .toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'location': location?.toJson(),
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class V2PermissionSavedListResponse {
  /// Создаёт модель из полей.
  V2PermissionSavedListResponse({required this.data});
  final List<PermissionSavedInfo> data;

  /// Разбирает JSON в [Object] типа V2PermissionSavedListResponse.
  factory V2PermissionSavedListResponse.fromJson(Map<String, Object?> json) {
    return V2PermissionSavedListResponse(
      data: (json['data'] as List)
          .map((e) => PermissionSavedInfo.fromJson(e as Map<String, Object?>))
          .toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class V2SessionPermissionCreateResponse {
  /// Создаёт модель из полей.
  V2SessionPermissionCreateResponse({required this.data});
  final Map<String, dynamic> data;

  /// Разбирает JSON в [Object] типа V2SessionPermissionCreateResponse.
  factory V2SessionPermissionCreateResponse.fromJson(
    Map<String, Object?> json,
  ) {
    return V2SessionPermissionCreateResponse(
      data: (json['data'] as Map).map((k, v) => MapEntry(k as String, v)),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'data': data};
}

class V2SessionPermissionListResponse {
  /// Создаёт модель из полей.
  V2SessionPermissionListResponse({required this.data});
  final List<PermissionV2Request> data;

  /// Разбирает JSON в [Object] типа V2SessionPermissionListResponse.
  factory V2SessionPermissionListResponse.fromJson(Map<String, Object?> json) {
    return V2SessionPermissionListResponse(
      data: (json['data'] as List)
          .map((e) => PermissionV2Request.fromJson(e as Map<String, Object?>))
          .toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class V2SessionPermissionGetResponse {
  /// Создаёт модель из полей.
  V2SessionPermissionGetResponse({required this.data});
  final PermissionV2Request data;

  /// Разбирает JSON в [Object] типа V2SessionPermissionGetResponse.
  factory V2SessionPermissionGetResponse.fromJson(Map<String, Object?> json) {
    return V2SessionPermissionGetResponse(
      data: PermissionV2Request.fromJson(json['data'] as Map<String, Object?>),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {'data': data?.toJson()};
}

class V2FsListResponse {
  /// Создаёт модель из полей.
  V2FsListResponse({required this.location, required this.data});
  final LocationInfo location;
  final List<FileSystemEntry> data;

  /// Разбирает JSON в [Object] типа V2FsListResponse.
  factory V2FsListResponse.fromJson(Map<String, Object?> json) {
    return V2FsListResponse(
      location: LocationInfo.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as List)
          .map((e) => FileSystemEntry.fromJson(e as Map<String, Object?>))
          .toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'location': location?.toJson(),
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class V2FsFindResponse {
  /// Создаёт модель из полей.
  V2FsFindResponse({required this.location, required this.data});
  final LocationInfo location;
  final List<FileSystemEntry> data;

  /// Разбирает JSON в [Object] типа V2FsFindResponse.
  factory V2FsFindResponse.fromJson(Map<String, Object?> json) {
    return V2FsFindResponse(
      location: LocationInfo.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as List)
          .map((e) => FileSystemEntry.fromJson(e as Map<String, Object?>))
          .toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'location': location?.toJson(),
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class V2CommandListResponse {
  /// Создаёт модель из полей.
  V2CommandListResponse({required this.location, required this.data});
  final LocationInfo location;
  final List<CommandV2Info> data;

  /// Разбирает JSON в [Object] типа V2CommandListResponse.
  factory V2CommandListResponse.fromJson(Map<String, Object?> json) {
    return V2CommandListResponse(
      location: LocationInfo.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as List)
          .map((e) => CommandV2Info.fromJson(e as Map<String, Object?>))
          .toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'location': location?.toJson(),
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class V2SkillListResponse {
  /// Создаёт модель из полей.
  V2SkillListResponse({required this.location, required this.data});
  final LocationInfo location;
  final List<SkillV2Info> data;

  /// Разбирает JSON в [Object] типа V2SkillListResponse.
  factory V2SkillListResponse.fromJson(Map<String, Object?> json) {
    return V2SkillListResponse(
      location: LocationInfo.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as List)
          .map((e) => SkillV2Info.fromJson(e as Map<String, Object?>))
          .toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'location': location?.toJson(),
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class V2PtyListResponse {
  /// Создаёт модель из полей.
  V2PtyListResponse({required this.location, required this.data});
  final LocationInfo location;
  final List<Pty> data;

  /// Разбирает JSON в [Object] типа V2PtyListResponse.
  factory V2PtyListResponse.fromJson(Map<String, Object?> json) {
    return V2PtyListResponse(
      location: LocationInfo.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as List)
          .map((e) => Pty.fromJson(e as Map<String, Object?>))
          .toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'location': location?.toJson(),
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class V2PtyCreateResponse {
  /// Создаёт модель из полей.
  V2PtyCreateResponse({required this.location, required this.data});
  final LocationInfo location;
  final Pty data;

  /// Разбирает JSON в [Object] типа V2PtyCreateResponse.
  factory V2PtyCreateResponse.fromJson(Map<String, Object?> json) {
    return V2PtyCreateResponse(
      location: LocationInfo.fromJson(json['location'] as Map<String, Object?>),
      data: Pty.fromJson(json['data'] as Map<String, Object?>),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'location': location?.toJson(),
    'data': data?.toJson(),
  };
}

class V2PtyGetResponse {
  /// Создаёт модель из полей.
  V2PtyGetResponse({required this.location, required this.data});
  final LocationInfo location;
  final Pty data;

  /// Разбирает JSON в [Object] типа V2PtyGetResponse.
  factory V2PtyGetResponse.fromJson(Map<String, Object?> json) {
    return V2PtyGetResponse(
      location: LocationInfo.fromJson(json['location'] as Map<String, Object?>),
      data: Pty.fromJson(json['data'] as Map<String, Object?>),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'location': location?.toJson(),
    'data': data?.toJson(),
  };
}

class V2PtyUpdateResponse {
  /// Создаёт модель из полей.
  V2PtyUpdateResponse({required this.location, required this.data});
  final LocationInfo location;
  final Pty data;

  /// Разбирает JSON в [Object] типа V2PtyUpdateResponse.
  factory V2PtyUpdateResponse.fromJson(Map<String, Object?> json) {
    return V2PtyUpdateResponse(
      location: LocationInfo.fromJson(json['location'] as Map<String, Object?>),
      data: Pty.fromJson(json['data'] as Map<String, Object?>),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'location': location?.toJson(),
    'data': data?.toJson(),
  };
}

class V2PtyConnectTokenResponse {
  /// Создаёт модель из полей.
  V2PtyConnectTokenResponse({required this.location, required this.data});
  final LocationInfo location;
  final PtyTicketConnectToken data;

  /// Разбирает JSON в [Object] типа V2PtyConnectTokenResponse.
  factory V2PtyConnectTokenResponse.fromJson(Map<String, Object?> json) {
    return V2PtyConnectTokenResponse(
      location: LocationInfo.fromJson(json['location'] as Map<String, Object?>),
      data: PtyTicketConnectToken.fromJson(
        json['data'] as Map<String, Object?>,
      ),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'location': location?.toJson(),
    'data': data?.toJson(),
  };
}

class V2QuestionRequestListResponse {
  /// Создаёт модель из полей.
  V2QuestionRequestListResponse({required this.location, required this.data});
  final LocationInfo location;
  final List<QuestionV2Request> data;

  /// Разбирает JSON в [Object] типа V2QuestionRequestListResponse.
  factory V2QuestionRequestListResponse.fromJson(Map<String, Object?> json) {
    return V2QuestionRequestListResponse(
      location: LocationInfo.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as List)
          .map((e) => QuestionV2Request.fromJson(e as Map<String, Object?>))
          .toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'location': location?.toJson(),
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class V2SessionQuestionListResponse {
  /// Создаёт модель из полей.
  V2SessionQuestionListResponse({required this.data});
  final List<QuestionV2Request> data;

  /// Разбирает JSON в [Object] типа V2SessionQuestionListResponse.
  factory V2SessionQuestionListResponse.fromJson(Map<String, Object?> json) {
    return V2SessionQuestionListResponse(
      data: (json['data'] as List)
          .map((e) => QuestionV2Request.fromJson(e as Map<String, Object?>))
          .toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class V2ReferenceListResponse {
  /// Создаёт модель из полей.
  V2ReferenceListResponse({required this.location, required this.data});
  final LocationInfo location;
  final List<ReferenceInfo> data;

  /// Разбирает JSON в [Object] типа V2ReferenceListResponse.
  factory V2ReferenceListResponse.fromJson(Map<String, Object?> json) {
    return V2ReferenceListResponse(
      location: LocationInfo.fromJson(json['location'] as Map<String, Object?>),
      data: (json['data'] as List)
          .map((e) => ReferenceInfo.fromJson(e as Map<String, Object?>))
          .toList(),
    );
  }

  /// Сериализует модель в JSON.
  Map<String, Object?> toJson() => {
    'location': location?.toJson(),
    'data': data?.map((e) => e.toJson()).toList(),
  };
}
