# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a TypeScript-based enhancement system for Claude Code that provides auto-approval of safe operations and sound notifications. The project consists of TypeScript hooks that integrate with Claude Code's hooks system to improve workflow efficiency while maintaining security.

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

1. **PreToolUse Hook** (`command-filter.ts`): Evaluates each tool operation against blocked and allowed patterns. Operations matching allowed patterns are auto-approved; blocked patterns require confirmation; others prompt for user approval.

2. **Universal Sound Player** (`sound-player.ts`): Plays different system sounds based on the hook event type:
   - Stop events: Plays completion sound when Claude finishes
   - Notification events: Plays alert sound when Claude needs input
   - PreToolUse blocked events: Plays warning sound when dangerous command is blocked
   - Error events: Plays error sound when issues occur

3. **Logging Hooks** (`loggers/*.ts`): Record all hook activities to JSON files for debugging and analysis.

## Custom Commands

The repository includes pre-built commands in the `commands/` directory that provide workflow automation:

- **`/cpr`**: Commit, Push, and create Pull Request - Analyzes git status and intelligently handles the full workflow

Commands are markdown files containing prompts that Claude Code executes. They're installed to `~/.claude/commands/` and can be invoked by typing `/<command_name>`.

## Configuration

### Sound Notifications

The universal sound player (`sound-player.ts`) can be configured to play different sounds for different events. Settings are stored in `~/.claude/.env`:

```bash
# Edit the .env file
nano ~/.claude/.env

# Enable sound notifications:
SOUND_NOTIFICATIONS_ENABLED="true"

# Configure sounds for different events:
STOP_SOUND="Glass"                 # When Claude completes
NOTIFICATION_SOUND="Ping"          # When Claude needs input
PRETOOLUSE_BLOCK_SOUND="Basso"     # When command is blocked
ERROR_SOUND="Sosumi"               # When error occurs
```

Available sounds on macOS: Basso, Blow, Bottle, Frog, Funk, Glass, Hero, Morse, Ping, Pop, Purr, Sosumi, Submarine, Tink

To use the sound player, add it to any hook in your `settings.json`:
```json
{
  "Stop": [{"hooks": [{"command": "bun ~/.claude/hooks/ts/sound-player.ts"}]}],
  "Notification": [{"hooks": [{"command": "bun ~/.claude/hooks/ts/sound-player.ts"}]}]
}
```

### Command Filtering

The TypeScript command filter uses two JSON configuration files located in `~/.claude/hooks/ts/config/`:

1. **`allowed-commands.json`**: Patterns for commands that should be auto-approved
2. **`blocked-commands.json`**: Patterns for dangerous commands that always require confirmation

The filter checks patterns in this order:
1. Check blocked patterns first (always block if matched)
2. Check allowed patterns (auto-approve if matched)
3. Default to manual approval for everything else

## Working with Patterns

### Allowed Commands (`config/allowed-commands.json`)

The file contains regex patterns for safe operations:
- **Package managers**: npm, yarn, pnpm, bun commands
- **Build tools**: dotnet, make, msbuild
- **Version control**: git, gh (GitHub CLI)
- **Languages**: python, go, rust tools
- **Claude Code tools**: Glob, Grep, Read, Write, etc.

### Blocked Commands (`config/blocked-commands.json`)

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

- **`command-filter.ts`**: Auto-approval and blocking system for PreToolUse events
- **`sound-player.ts`**: Universal sound player that detects hook type and plays appropriate sounds
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