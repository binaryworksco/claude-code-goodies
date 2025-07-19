# Codebase Map

**Purpose**: Quick reference for key implementation locations and patterns in the codebase.
**Last Updated**: 2025-07-17

## Core Architecture

### Directory Structure
```
claude-code-goodies/
├── hooks/ts/              # TypeScript hook implementations
│   ├── command-filter/    # Auto-approval and blocking system
│   ├── sound-player/      # Cross-platform sound notifications
│   └── loggers/           # JSON activity logging
├── commands/              # Custom Claude Code commands
│   └── workflow/          # Project workflow automation
├── scripts/               # Installation and maintenance scripts
├── templates/             # Workflow documentation templates
└── .working/              # Project workflow documentation
```

### Key Components
| Component | Purpose | Location | Notes |
|-----------|---------|----------|-------|
| Command Filter | Auto-approval/blocking of commands | `hooks/ts/command-filter/command-filter.ts` | Uses regex pattern matching |
| Sound Player | Audio notifications for events | `hooks/ts/sound-player/sound-player.ts` | Platform-specific audio commands |
| Activity Logger | JSON logging of hook events | `hooks/ts/loggers/*.ts` | Separate logger per event type |
| Type Definitions | Shared TypeScript types | `hooks/ts/loggers/lib/types.ts` | Common interfaces |
| Install Scripts | Automated setup | `scripts/install-*.sh` | Handles hooks and commands |
| Workflow Commands | Project management | `commands/workflow/*.md` | Markdown-based prompts |

## Key Patterns

### Design Patterns
- **Hook Architecture**: Event-driven stdin/stdout processing - See `hooks/ts/command-filter/command-filter.ts:24-45`
- **Configuration Loading**: JSON files in user directory - Pattern in `hooks/ts/command-filter/command-filter.ts:48-75`
- **Cross-Platform Support**: Platform detection and fallbacks - Example in `hooks/ts/sound-player/sound-player.ts:60-95`
- **Structured Logging**: JSON append logs - Implementation in `hooks/ts/loggers/lib/logger.ts`

### Code Conventions
- **TypeScript Execution**: Direct execution with bun runtime - All `.ts` files start with `#!/usr/bin/env bun`
- **Configuration Files**: JSON format in `config/` subdirectories - See `hooks/ts/command-filter/config/`
- **Environment Variables**: Settings in `~/.claude/.env` - Loaded via `process.env`
- **Error Handling**: Try-catch with graceful fallbacks - Pattern throughout hooks

## Common Operations

### Adding Features
- **New Hook**: Create TypeScript file in `hooks/ts/`, add to `settings.json`
- **New Command**: Create markdown file in `commands/`, run `install-commands.sh`
- **New Pattern**: Add to `allowed-commands.json` or `blocked-commands.json`

### Testing
- **Hook Testing**: Run commands that trigger the hook, check logs
- **Command Testing**: Type `/<command-name>` in Claude Code
- **Log Viewing**: Use `jq` to parse JSON logs: `jq '.' logs/hooks/*.json`

### Configuration
- **User Settings**: Edit `~/.claude/.env` for environment variables
- **Command Patterns**: Edit JSON files in `hooks/ts/command-filter/config/`
- **Claude Settings**: Modify `~/.claude/settings.json` to enable/disable hooks

## Integration Points
- **Claude Code Hooks**: PreToolUse, PostToolUse, Stop, Notification events
- **File System**: Logs to `./logs/` and `~/.claude/logs/`
- **Platform Audio**: afplay (macOS), paplay/aplay (Linux), PowerShell (Windows)
- **Git Integration**: Commands use git CLI for version control operations