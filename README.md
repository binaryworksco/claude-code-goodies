# Claude Code Goodies

Community hooks and tools to make Claude Code safer, smarter, and more notifiable

<p align="center">
  <img src="https://img.shields.io/badge/Claude%20Code-Enhanced-blue" alt="Claude Code Enhanced">
  <img src="https://img.shields.io/badge/License-MIT-green" alt="MIT License">
  <img src="https://img.shields.io/badge/Telegram-Ready-blue?logo=telegram" alt="Telegram Ready">
</p>

## 🚀 What is this?

This repository contains a collection of hooks and tools that enhance your Claude Code experience by:

- **🛡️ Auto-approving safe operations** - No more interruptions for routine commands
- **🚨 Dangerous command detection** - Automatically blocks potentially harmful operations
- **📱 Telegram notifications** - Get real-time updates when Claude needs you or completes tasks
- **📊 Separated logging** - Track approved vs blocked operations easily
- **🔒 Security-first approach** - Whitelist-based approval system with dangerous command blocking
- **⚡ Zero-config for common tools** - Pre-configured patterns for npm, dotnet, git, and more
- **⌨️ Custom commands** - Pre-built workflow commands for common development tasks

## 🎯 Why use these hooks?

Claude Code is powerful, but constantly approving routine operations interrupts your flow. These hooks:

1. **Save time** - Auto-approve safe operations like `npm install`, `dotnet build`, `ls`, etc.
2. **Stay informed** - Get Telegram notifications for operations that need your attention
3. **Maintain security** - Only whitelisted operations are auto-approved
4. **Track activity** - Separate logs for approved and blocked operations
5. **Customize easily** - Simple text file configuration

## 📦 Installation

### Prerequisites

- Claude Code installed and working
- `jq` command-line tool (for JSON parsing)
  ```bash
  # macOS
  brew install jq
  
  # Ubuntu/Debian
  sudo apt-get install jq
  
  # Other
  # https://stedolan.github.io/jq/download/
  ```

### Installation

#### Quick Installation (Recommended)

1. **Clone the repository**
   ```bash
   git clone https://github.com/binaryworksco/claude-code-goodies.git
   cd claude-code-goodies
   ```

2. **Run the installation scripts**
   ```bash
   ./scripts/install-hooks.sh
   ./scripts/install-commands.sh
   ```

   This will:
   - Create necessary directories
   - Copy all hook files and commands
   - Create a `.env` configuration file
   - Preserve any existing configuration

#### Manual Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/binaryworksco/claude-code-goodies.git
   cd claude-code-goodies
   ```

2. **Create the hooks directory**
   ```bash
   mkdir -p ~/.claude/hooks ~/.claude/logs
   ```

3. **Copy the hook files and commands**
   ```bash
   cp hooks/*.sh ~/.claude/hooks/
   cp hooks/allowed-tasks.txt ~/.claude/hooks/
   cp hooks/dangerous-tasks.txt ~/.claude/hooks/
   chmod +x ~/.claude/hooks/*.sh
   
   # Copy commands
   mkdir -p ~/.claude/commands
   cp commands/*.md ~/.claude/commands/
   
   # Copy the .env template
   cp .env.example ~/.claude/.env
   ```

4. **Configure Telegram (Optional but recommended)**
   
   Create a Telegram bot:
   - Message [@BotFather](https://t.me/botfather) on Telegram
   - Send `/newbot` and follow the instructions
   - Save your bot token (looks like `1234567890:ABC-DEF1234ghIkl-zyx57W2v1u123ew11`)
   - Start a chat with your bot and send any message
   - Visit `https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates`
   - Find your `chat_id` in the response

   Add your credentials to the configuration file:
   ```bash
   # Edit the .env file
   nano ~/.claude/.env
   
   # Add your credentials:
   TELEGRAM_BOT_TOKEN="your-bot-token-here"
   TELEGRAM_CHAT_ID="your-chat-id-here"
   ```

5. **Configure Claude Code settings**
   ```bash
   cp settings.json.example ~/.claude/settings.json
   ```

6. **Restart Claude Code**
   ```bash
   # Exit Claude Code completely, then start it again
   ```

## 🔧 Configuration

### Environment Variables (`~/.claude/.env`)

The `.env` file stores your Telegram credentials and other configuration:

```bash
# Telegram Bot Configuration
TELEGRAM_BOT_TOKEN="your-bot-token-here"
TELEGRAM_CHAT_ID="your-chat-id-here"
```

**Important**: Your credentials are stored separately from the hook scripts, so they won't be overwritten when updating the hooks.

### Allowed Tasks (`~/.claude/hooks/allowed-tasks.txt`)

This file controls what operations are auto-approved. It uses regex patterns:

```bash
# Tasks
^Run tests.*
^Build.*
^Install dependencies.*

# Bash commands
^npm (install|test|build)
^dotnet (build|test|run)
^echo 
^ls
^cat

# File operations
^Read$       # Allow all file reads
^WebFetch$   # Allow all web fetches
^src/.*\.js$ # Allow editing JS files in src/

# Exclusions (never auto-approve these)
!\.env
!credentials
!secret
```

### Adding New Patterns

```bash
# Allow a specific command
echo '^yarn install$' >> ~/.claude/hooks/allowed-tasks.txt

# Allow all operations for a tool
echo '^Glob$' >> ~/.claude/hooks/allowed-tasks.txt

# Allow file operations in a directory
echo '^src/.*\.(js|ts)$' >> ~/.claude/hooks/allowed-tasks.txt
```

## 📱 Telegram Notifications

When configured, you'll receive notifications for:

### Operations requiring approval
```
⏳ Claude Code Action Required

Message: Tool usage requires approval

📍 Please return to Claude Code to review and respond.
```

### Session completions
```
🚀 Claude Code session complete for project: `YourProject`
```

**Note**: The approval notification only sends when Claude is actually waiting for your input mid-task. Completion notifications won't trigger duplicate alerts.

## ⌨️ Custom Commands

The repository includes pre-built commands that automate common development workflows:

### Available Commands

- **`/cpr`** - Commit, Push, and create Pull Request
  - Analyzes git status and intelligently handles staging, committing, pushing, and PR creation
  - Makes smart decisions about commit messages and PR descriptions

### Using Commands

Commands are installed to `~/.claude/commands/` and can be used by typing `/<command_name>` in Claude Code:

```bash
# Example: Use the commit/push/PR command
/cpr

# Claude will analyze your git status and help you ship your changes
```

### Creating Custom Commands

Commands are markdown files with prompts that Claude Code executes. To create your own:

1. Create a `.md` file in the `commands/` directory
2. Write your prompt with any special instructions
3. Use `$ARGUMENTS` to accept parameters
4. Run `./scripts/install-commands.sh` to install

## 📊 Monitoring

### View logs
```bash
# See approved operations
tail -f ~/.claude/logs/auto-approve.log

# See blocked operations
tail -f ~/.claude/logs/auto-blocked.log

# See dangerous commands
tail -f ~/.claude/logs/dangerous-commands.log

# See approval notifications
tail -f ~/.claude/logs/approval-notifications.log

# Count today's operations
echo "Approved: $(grep -c "AUTO-APPROVED" ~/.claude/logs/auto-approve.log)"
echo "Blocked: $(grep -c "BLOCKED" ~/.claude/logs/auto-blocked.log)"
echo "Dangerous: $(grep -c "DANGEROUS" ~/.claude/logs/dangerous-commands.log)"
```

## 🛠️ Customization

### Enable verbose logging

For debugging or detailed logging, edit `~/.claude/hooks/auto-approve.sh`:

```bash
# Change from:
VERBOSE_LOGGING=false

# To:
VERBOSE_LOGGING=true
```

This provides detailed pattern matching information helpful for troubleshooting.

### Modify auto-approval patterns
Edit `~/.claude/hooks/allowed-tasks.txt` - changes take effect immediately!

### Disable Telegram notifications
Comment out the `send_telegram` function calls in the hook scripts.

### Change notification format
Edit the `MESSAGE` variable in the hook scripts to customize notification text.

## 🧪 Testing

Test if hooks are working:

```bash
# This should auto-approve (if echo is in allowed-tasks.txt)
echo "Hello, World!"

# This should notify and ask for permission
rm -rf /tmp/test
```

## 📁 Repository Structure

```
claude-code/
├── README.md
├── LICENSE
├── hooks/
│   ├── auto-approve.sh      # Main auto-approval hook
│   ├── telegram-completion.sh # Session completion notifications
│   ├── approval-notification.sh # Notification only when approval needed
│   ├── allowed-tasks.txt    # Patterns for auto-approval
│   └── dangerous-tasks.txt  # Patterns for dangerous commands
└── settings/
    └── settings.json        # Claude Code hooks configuration
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. Some ideas:

- Additional notification methods (Discord, Slack, etc.)
- More sophisticated approval patterns
- Tool-specific configurations
- Performance optimizations

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Thanks to Anthropic for creating Claude Code
- Inspired by the need for a smoother development workflow
- Community feedback and contributions

## ⚠️ Security Note

These hooks execute with your user permissions. Always:
- Review the hook scripts before installing
- Be careful with what patterns you add to `allowed-tasks.txt`
- Never auto-approve destructive commands
- Keep your Telegram credentials private

## 🐛 Troubleshooting

### Hooks not triggering
1. Run `/hooks` in Claude Code to verify they're loaded
2. Check `~/.claude/settings.json` exists and is valid JSON
3. Restart Claude Code completely

### Telegram not working
1. Verify your bot token and chat ID are correct
2. Check that your bot is started (send `/start` to it)
3. Look for errors in the logs

### Commands not auto-approving
1. Check the pattern in `allowed-tasks.txt`
2. Verify regex syntax (use `^` and `$` for exact matches)
3. Check logs to see what pattern is being tested

---

Made with ❤️ for the Claude Code community