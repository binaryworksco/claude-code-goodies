# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a TypeScript-based enhancement system for Claude Code that provides auto-approval of safe operations and sound notifications. The project consists of TypeScript hooks that integrate with Claude Code's hooks system to improve workflow efficiency while maintaining security.

## Feature-Centric Workflow

This project uses a feature-centric workflow where all artifacts related to a feature, PRD, or bug are stored together in dedicated folders. This ensures better organization and session continuity.

### Quick Start for New Sessions
1. Run `/status` to see all active work
2. Run `/resume` to continue the most recent session
3. Or start new work with `/generate-feature`, `/generate-prd`, or `/report-bug`

### Workflow Commands
- **`/setup-workflow`**: Initialize the project's workflow structure
- **`/generate-feature`**: Create a new feature with session tracking
- **`/generate-prd`**: Create a Product Requirements Document for major features
- **`/resume`**: Continue working on active sessions
- **`/switch-feature`**: Switch between different active features
- **`/status`**: View overview of all active work

### Session Management
Each feature/PRD/bug maintains its own session state in a dedicated folder:
```
/docs/features/feature-XXXX-name/
├── feature-XXXX-name.md    # Feature document
├── session.md              # Current progress and state
├── decisions.md            # Key decisions log
├── notes.md               # Working notes
└── agents/                # Multi-agent coordination
```

Always check for active sessions when starting work and update session.md as you progress.

## Key Commands

### Installation
```bash
# Create necessary directories
mkdir -p ~/.claude/hooks ~/.claude/logs

# Run the installation scripts (recommended)
./scripts/install-hooks.sh
./scripts/install-commands.sh

# Configure Claude Code settings
cp settings.json.example ~/.claude/settings.json

# Or use advanced settings with all hooks enabled
cp settings-advanced.json.example ~/.claude/settings.json
```

### Testing Hooks
```bash
# Test auto-approval (should auto-approve if pattern matches)
echo "Hello, World!"

# Test blocking (should ask for permission)
rm -rf /tmp/test

# View command filter logs
tail -f ~/.claude/logs/hooks/command-filter.log

# View hook activity logs (JSON format)
jq '.' ./logs/hooks/pre-tool-use.json
jq '.' ./logs/hooks/notification.json
```

## Architecture

The system uses Claude Code's hook infrastructure to intercept tool operations:

1. **PreToolUse Hook** (`command-filter/command-filter.ts`): Evaluates each tool operation against blocked and allowed patterns. Operations matching allowed patterns are auto-approved; blocked patterns require confirmation; others prompt for user approval.

2. **Universal Sound Player** (`sound-player/sound-player.ts`): Plays WAV files based on the hook event type:
   - Stop events: Plays completion sound when Claude finishes
   - Notification events: Plays alert sound when Claude needs input
   - PreToolUse blocked events: Plays warning sound when dangerous command is blocked
   - Error events: Plays error sound when issues occur
   - Uses local WAV files for consistent sound across all platforms

3. **Logging Hooks** (`loggers/*.ts`): Record all hook activities to JSON files for debugging and analysis.

## Custom Commands

The repository includes pre-built commands in the `commands/` directory that provide workflow automation:

- **`/cpr`**: Commit, Push, and create Pull Request - Analyzes git status and intelligently handles the full workflow

Commands are markdown files containing prompts that Claude Code executes. They're installed to `~/.claude/commands/` and can be invoked by typing `/<command_name>`.

## Configuration

### Sound Notifications

The universal sound player (`sound-player/sound-player.ts`) plays WAV files for different events. Settings are stored in `~/.claude/.env`:

```bash
# Edit the .env file
nano ~/.claude/.env

# Enable sound notifications:
SOUND_NOTIFICATIONS_ENABLED="true"

# Configure sounds for different events:
STOP_SOUND="mixkit-happy-bell-alert.wav"     # When Claude completes
NOTIFICATION_SOUND="mixkit-happy-bell-alert.wav"  # When Claude needs input
PRETOOLUSE_BLOCK_SOUND="mixkit-happy-bell-alert.wav" # When command is blocked
ERROR_SOUND="mixkit-happy-bell-alert.wav"    # When error occurs
```

The sound player uses local WAV files stored in the `sound-player/wav/` directory, ensuring consistent audio across all platforms.

You can specify different WAV files for each event type in your `~/.claude/.env`:
```bash
STOP_SOUND="completion.wav"          # Custom sound for completion
NOTIFICATION_SOUND="alert.wav"       # Custom sound for notifications
PRETOOLUSE_BLOCK_SOUND="warning.wav" # Custom sound for blocked commands
ERROR_SOUND="error.wav"              # Custom sound for errors
```

WAV files can be:
- Filenames from the `wav/` directory (e.g., `"mixkit-happy-bell-alert.wav"`)
- Absolute paths to WAV files anywhere on your system (e.g., `"/Users/you/sounds/custom.wav"`)

To use the sound player, add it to any hook in your `settings.json`:
```json
{
  "Stop": [{"hooks": [{"command": "bun ~/.claude/hooks/ts/sound-player/sound-player.ts"}]}],
  "Notification": [{"hooks": [{"command": "bun ~/.claude/hooks/ts/sound-player/sound-player.ts"}]}]
}
```

### Command Filtering

The TypeScript command filter uses two JSON configuration files located in `~/.claude/hooks/ts/command-filter/config/`:

1. **`allowed-commands.json`**: Patterns for commands that should be auto-approved
2. **`blocked-commands.json`**: Patterns for dangerous commands that always require confirmation

The filter checks patterns in this order:
1. Check blocked patterns first (always block if matched)
2. Check allowed patterns (auto-approve if matched)
3. Default to manual approval for everything else

## Working with Patterns

### Allowed Commands (`command-filter/config/allowed-commands.json`)

The file contains regex patterns for safe operations:
- **Package managers**: npm, yarn, pnpm, bun commands
- **Build tools**: dotnet, make, msbuild
- **Version control**: git, gh (GitHub CLI)
- **Languages**: python, go, rust tools
- **Claude Code tools**: Glob, Grep, Read, Write, etc.

### Blocked Commands (`command-filter/config/blocked-commands.json`)

Contains patterns for dangerous operations:
- **Destructive**: rm -rf, dd, mkfs
- **System**: sudo, chmod 777, package removals
- **Database**: DROP, TRUNCATE commands
- **Git dangerous**: force push, git rm
- **Security risks**: curl | sh patterns

## TypeScript Hooks

All hooks are written in TypeScript and run with `bun`:

- **No installation required**: Uses `bun` for execution (pre-installed for most Claude Code users)
- **Cross-platform**: Works on Windows, macOS, and Linux
- **Type-safe**: Full TypeScript type checking
- **JSON logging**: Structured logs in `./logs/hooks/`
- **Modular design**: Shared utilities in `lib/` directory

### Available Hooks

- **`command-filter/command-filter.ts`**: Auto-approval and blocking system for PreToolUse events
- **`sound-player/sound-player.ts`**: Universal sound player that plays WAV files based on hook type
- **`loggers/pre-tool-use.ts`**: Logs all pre-tool-use events to JSON
- **`loggers/post-tool-use.ts`**: Logs all post-tool-use events to JSON
- **`loggers/notification.ts`**: Logs all notification events to JSON
- **`loggers/stop.ts`**: Logs all stop events to JSON
- **`loggers/subagent-stop.ts`**: Logs all subagent-stop events to JSON

## Logging

The TypeScript hooks log to both user and project directories:
- Command filter logs: `~/.claude/logs/hooks/command-filter.log` (user directory)
- Hook activity logs: `./logs/hooks/*.json` (project directory)

The dual logging approach ensures:
- Command filter decisions are persisted across sessions
- Hook activity logs are available for local debugging without cluttering the user directory

Log entries include:
- Timestamp
- Tool name and input
- Matched patterns (or `noMatch: true`)
- Decision made
- Process information

## Security Considerations

- All hooks execute with user permissions
- Blocked patterns are checked before allowed patterns
- Sensitive files are explicitly blocked (`.env`, `.ssh`, etc.)
- Configuration is stored separately from code
- Logs are stored locally and gitignored