# TypeScript Hooks for Claude Code

Cross-platform TypeScript hooks that log all Claude Code activities to JSON files.

## Features

- **Zero installation** - Uses `npx tsx` to run TypeScript directly
- **Cross-platform** - Works on Windows, macOS, and Linux
- **JSON logging** - All hook inputs are logged as valid JSON arrays
- **Full chat history** - Stop hooks capture the complete conversation
- **Process information** - Each log entry includes platform, Node version, and working directory

## Installation

1. Copy the TypeScript hooks to your Claude Code directory:
   ```bash
   cp -r hooks/ts ~/.claude/hooks/
   ```
   
   Or use the installation script:
   ```bash
   ./scripts/install-hooks.sh
   ```

2. Copy and configure the settings file:
   ```bash
   cp settings-typescript.json.example ~/.claude/settings.json
   ```

That's it! No `npm install` required.

## How It Works

The hooks use `npx tsx` to run TypeScript files directly without compilation:

```json
{
  "type": "command",
  "command": "npx tsx ~/.claude/hooks/ts/loggers/pre-tool-use.ts"
}
```

When Claude Code triggers a hook:
1. `npx` downloads `tsx` if not cached (happens once)
2. `tsx` executes the TypeScript file directly
3. The hook logs input to `./logs/hooks/{hook-name}.json`
4. Logs are appended as a valid JSON array

## Log Files

Logs are written to the project's `.claude` directory:

- `./.claude/logs/hooks/pre-tool-use.json` - Tool usage before execution
- `./.claude/logs/hooks/post-tool-use.json` - Tool results after execution  
- `./.claude/logs/hooks/notification.json` - All Claude Code notifications
- `./.claude/logs/hooks/stop.json` - Session end with full chat history
- `./.claude/logs/hooks/subagent-stop.json` - Subagent completion logs
- `./.claude/logs/hooks/raw-input.json` - Raw input logger for debugging

## Example Log Entry

Logs now contain just the raw data from Claude Code:

```json
[
  {
    "session_id": "abc-123-def",
    "transcript_path": "/tmp/claude/transcript-abc-123.jsonl",
    "hook_event_name": "PreToolUse",
    "tool_name": "Bash",
    "tool_input": {
      "command": "echo \"Hello World\"",
      "description": "Test command"
    }
  },
  {
    "session_id": "abc-123-def",
    "transcript_path": "/tmp/claude/transcript-abc-123.jsonl",
    "hook_event_name": "PreToolUse",
    "tool_name": "Read",
    "tool_input": {
      "file_path": "/Users/username/test.txt"
    }
  }
]
```

## Viewing Logs

Since logs are valid JSON, you can use any JSON tool:

```bash
# Pretty print with jq
cat .claude/logs/hooks/pre-tool-use.json | jq '.'

# Get all Bash commands
cat .claude/logs/hooks/pre-tool-use.json | jq '.[] | select(.tool_name == "Bash") | .tool_input.command'

# View latest entry
cat .claude/logs/hooks/stop.json | jq '.[-1]'
```

## Combining with Existing Hooks

TypeScript hooks can coexist with shell hooks. You can:
- Run both by adding multiple hooks in settings.json
- Use TypeScript for logging and shell for auto-approval
- Gradually migrate from shell to TypeScript

## Testing Hooks Manually

The hooks expect JSON input via stdin. To test them manually:

```bash
# Test pre-tool-use hook
echo '{"session_id":"test-123","transcript_path":"/tmp/transcript.jsonl","hook_event_name":"PreToolUse","tool_name":"Bash","tool_input":{"command":"ls"}}' | npx tsx ~/.claude/hooks/ts/loggers/pre-tool-use.ts

# Check the logs
cat .claude/logs/hooks/pre-tool-use.json | jq '.'
```

Note: When run directly, the terminal will pause waiting for input. Always pipe JSON data to the hooks.

## Troubleshooting

- **"command not found: npx"** - Install Node.js (npx comes with npm)
- **Logs not appearing** - Check the current working directory's `.claude/logs/hooks/` folder
- **Permission denied** - Ensure hooks have execute permissions: `chmod +x ~/.claude/hooks/ts/loggers/*.ts`
- **Terminal hangs when running hook** - The hook is waiting for JSON input. Use echo and pipe: `echo '{}' | npx tsx ...`
- **Hide logs from git** - Add `.claude/` to your `.gitignore` file to keep logs private