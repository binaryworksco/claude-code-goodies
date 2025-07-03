# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a shell script-based enhancement system for Claude Code that provides auto-approval of safe operations and Telegram notifications. The project consists of bash hooks that integrate with Claude Code's hooks system to improve workflow efficiency while maintaining security.

## Key Commands

### Installation
```bash
# Create necessary directories
mkdir -p ~/.claude/hooks ~/.claude/logs

# Copy hook files
cp hooks/*.sh ~/.claude/hooks/
cp hooks/allowed-tasks.txt ~/.claude/hooks/
chmod +x ~/.claude/hooks/*.sh

# Configure Claude Code
cp settings.json.example ~/.claude/settings.json
```

### Testing Hooks
```bash
# Test auto-approval (should auto-approve if pattern matches)
echo "Hello, World!"

# Test blocking (should notify and ask for permission)
rm -rf /tmp/test

# View logs
tail -f ~/.claude/logs/auto-approve.log
tail -f ~/.claude/logs/auto-blocked.log
```

## Architecture

The system uses Claude Code's hook infrastructure to intercept tool operations:

1. **PreToolUse Hook** (`auto-approve.sh`): Evaluates each tool operation against whitelist patterns in `allowed-tasks.txt`. Operations matching patterns are auto-approved; others prompt for user approval.

2. **Notification Hook** (`notification.sh`): Sends Telegram alerts when Claude Code needs user input for blocked operations.

3. **Stop Hook** (`telegram-completion.sh`): Sends a completion notification when a Claude Code session ends.

## Working with Allowed Patterns

The `allowed-tasks.txt` file uses regex patterns to control auto-approval:

- **Task patterns**: Match against task titles (e.g., `^Run tests.*`)
- **Command patterns**: Match bash commands (e.g., `^npm install$`)
- **File patterns**: Match file paths for read/write operations
- **Exclusion patterns**: Start with `!` to never auto-approve (e.g., `!\.env`)

When modifying patterns:
1. Test regex carefully - patterns are matched against the full input
2. Use `^` and `$` anchors for exact matches
3. Changes take effect immediately without restart
4. Check logs to verify pattern matching behavior

## Dangerous Command Detection

The system includes a safety feature that checks for dangerous commands before auto-approval. The `dangerous-tasks.txt` file contains patterns for potentially harmful operations that should always require manual approval.

### How it works:
1. **Priority checking**: Dangerous patterns are checked BEFORE allowed patterns
2. **Immediate bypass**: If a command matches a dangerous pattern, it bypasses auto-approval entirely
3. **Separate logging**: Dangerous commands are logged to `~/.claude/logs/dangerous-commands.log`
4. **Telegram alerts**: Special notifications are sent for dangerous command detections

### Common dangerous patterns include:
- Destructive file operations (`rm -rf`, `dd`, `mkfs`)
- System modifications (`sudo`, package removals)
- Git force operations (`git push --force`)
- Database drops and truncations
- Commands that pipe to shell (`curl ... | sh`)

Even if a command matches an allowed pattern, it will be blocked if it also matches a dangerous pattern, providing an extra layer of safety.

## Logging Configuration

The auto-approve hook supports configurable verbosity levels:

- **Normal Mode (default)**: `VERBOSE_LOGGING=false`
  - Concise single-line logs for each operation
  - Shows only essential information: operation type and approval status
  - Example: `[Date] Bash: npm install express` → `✅ AUTO-APPROVED (matched: ^npm install.*)`

- **Verbose Mode**: `VERBOSE_LOGGING=true`
  - Detailed debugging information
  - Shows pattern matching process, full requests, and responses
  - Useful for troubleshooting pattern matching issues

To enable verbose logging, edit `~/.claude/hooks/auto-approve.sh` and set `VERBOSE_LOGGING=true`.

## Security Considerations

- All hooks execute with user permissions
- Only whitelisted operations are auto-approved
- Sensitive files are explicitly excluded via `!` patterns
- Telegram credentials must be kept secure
- Logs are stored locally in `~/.claude/logs/`