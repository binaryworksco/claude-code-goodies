// Types for Claude Code hook inputs and outputs
// Based on official Claude Code documentation

// Common fields for all hooks
export interface HookInput {
  session_id: string;
  transcript_path: string;
  hook_event_name: string;
}

// PreToolUse hook
export interface PreToolUseInput extends HookInput {
  hook_event_name: 'PreToolUse';
  tool_name: string;
  tool_input: Record<string, any>;
}

export interface PreToolUseDecision {
  decision?: 'approve' | 'deny';
  reason?: string;
  info?: string;
}

// PostToolUse hook
export interface PostToolUseInput extends HookInput {
  hook_event_name: 'PostToolUse';
  tool_name: string;
  tool_input: Record<string, any>;
  tool_response: Record<string, any>;
}

// Notification hook
export interface NotificationInput extends HookInput {
  hook_event_name: 'Notification';
  message: string;
}

// Stop hook
export interface StopInput extends HookInput {
  hook_event_name: 'Stop';
  stop_hook_active?: boolean;
}

// SubagentStop hook
export interface SubagentStopInput extends HookInput {
  hook_event_name: 'SubagentStop';
  stop_hook_active?: boolean;
}

// Message structure for transcripts
export interface TranscriptMessage {
  role: 'user' | 'assistant' | 'system';
  content: string;
  timestamp?: string;
}

// Log entry structure for our logging
export interface LogEntry<T = any> {
  timestamp: string;
  hookType: string;
  input: T;
  processInfo: {
    pid: number;
    platform: string;
    nodeVersion: string;
    cwd: string;
  };
}