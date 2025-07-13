# Claude Code Goodies

Community hooks and tools to make Claude Code safer, smarter, and more notifiable

<p align="center">
  <img src="https://img.shields.io/badge/Claude%20Code-Enhanced-blue" alt="Claude Code Enhanced">
  <img src="https://img.shields.io/badge/License-MIT-green" alt="MIT License">
</p>

## 🚀 What is this?

This repository contains a collection of hooks and tools that enhance your Claude Code experience by:

- **🛡️ Auto-approving safe operations** - No more interruptions for routine commands
- **🚨 Dangerous command detection** - Automatically blocks potentially harmful operations
- **🔊 Sound notifications** - Get audio alerts when Claude completes tasks (macOS)
- **📊 Separated logging** - Track approved vs blocked operations easily
- **🔒 Security-first approach** - Whitelist-based approval system with dangerous command blocking
- **⚡ Zero-config for common tools** - Pre-configured patterns for npm, dotnet, git, and more
- **⌨️ Custom commands** - Pre-built workflow commands for common development tasks

## 🎯 Why use these hooks?

Claude Code is powerful, but constantly approving routine operations interrupts your flow. These hooks:

1. **Save time** - Auto-approve safe operations like `npm install`, `dotnet build`, `ls`, etc.
2. **Stay informed** - Get sound notifications when Claude completes tasks
3. **Maintain security** - Only whitelisted operations are auto-approved
4. **Track activity** - Separate logs for approved and blocked operations
5. **Customize easily** - Simple text file configuration

## 📦 Installation

### Prerequisites

- Claude Code installed and working
- Bun runtime (for TypeScript execution) - Most users have this pre-installed
  ```bash
  # Check if bun is installed
  bun --version
  
  # If not installed, visit: https://bun.sh
  
  # For WSL users: Install bun in WSL environment
  curl -fsSL https://bun.sh/install | bash
  ```
- `jq` command-line tool (optional, for viewing JSON logs)
  ```bash
  # macOS
  brew install jq
  
  # Ubuntu/Debian/WSL
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
   # Copy TypeScript hooks
   cp -r hooks/ts ~/.claude/hooks/
   chmod +x ~/.claude/hooks/ts/*.ts
   
   # Copy commands
   mkdir -p ~/.claude/commands
   cp commands/*.md ~/.claude/commands/
   
   # Copy the .env template
   cp .env.example ~/.claude/.env
   ```

4. **Configure settings (Optional)**
   
   Edit the configuration file to set your preferences:
   ```bash
   # Edit the .env file
   nano ~/.claude/.env
   
   # Enable sound notifications (macOS):
   SOUND_NOTIFICATIONS_ENABLED="true"
   COMPLETION_SOUND="Glass"  # Choose from: Basso, Blow, Bottle, Frog, Funk, Glass, Hero, Morse, Ping, Pop, etc.
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

The `.env` file stores your configuration preferences:

```bash
# Sound Notification Settings
SOUND_NOTIFICATIONS_ENABLED="true"

# Specify WAV files for different events
STOP_SOUND="mixkit-happy-bell-alert.wav"         # When Claude completes
NOTIFICATION_SOUND="mixkit-happy-bell-alert.wav"  # When Claude needs input
PRETOOLUSE_BLOCK_SOUND="mixkit-happy-bell-alert.wav" # When command is blocked
ERROR_SOUND="mixkit-happy-bell-alert.wav"        # When an error occurs

# Logging Settings
COMMAND_FILTER_LOG_ENABLED="true"  # Set to "false" to disable command filter logging
```

**Important**: Your configuration is stored separately from the hook scripts, so it won't be overwritten when updating the hooks.

### Command Filtering Configuration

The TypeScript command filter uses two JSON configuration files:

1. **`~/.claude/hooks/ts/command-filter/config/allowed-commands.json`** - Patterns for safe operations that auto-approve
2. **`~/.claude/hooks/ts/command-filter/config/blocked-commands.json`** - Patterns for dangerous operations that always require confirmation

The filter checks patterns in this order:
1. Check blocked patterns first (always block if matched)
2. Check allowed patterns (auto-approve if matched)  
3. Default to manual approval for everything else

#### Example Allowed Patterns
```json
{
  "patterns": [
    "^npm (install|test|build|run)",
    "^echo ",
    "^ls",
    "^git (status|diff|log|add|commit)",
    "^Read$",
    "^Glob$"
  ]
}
```

#### Example Blocked Patterns
```json
{
  "patterns": [
    "rm -rf",
    "sudo",
    "DROP TABLE",
    "git push.*--force"
  ]
}
```

### Adding New Patterns

Edit the JSON configuration files to add new patterns:

```bash
# Edit allowed commands
nano ~/.claude/hooks/ts/command-filter/config/allowed-commands.json

# Edit blocked commands  
nano ~/.claude/hooks/ts/command-filter/config/blocked-commands.json
```

Example additions:
```json
// Allow a specific command
"^yarn install$"

// Allow all operations for a tool
"^Glob$"

// Allow file operations in a directory
"^src/.*\\.(js|ts)$"
```

## 🔊 Sound Notifications

The universal sound player plays different sounds for different Claude Code events across multiple platforms:

### Sound Types
- **Completion Sound**: When Claude finishes a task
- **Notification Sound**: When Claude needs your input
- **Blocked Command Sound**: When a dangerous command is blocked
- **Error Sound**: When an error occurs

### Setup
1. Add `SOUND_NOTIFICATIONS_ENABLED="true"` to `~/.claude/.env`
2. Add the sound-player hook to your desired hooks in `settings.json`:
   ```json
   "Stop": [{"hooks": [{"command": "bun ~/.claude/hooks/ts/sound-player/sound-player.ts"}]}],
   "Notification": [{"hooks": [{"command": "bun ~/.claude/hooks/ts/sound-player/sound-player.ts"}]}]
   ```
3. Customize sounds in `~/.claude/.env`:
   ```bash
   # Use WAV files from the wav/ directory
   STOP_SOUND="mixkit-happy-bell-alert.wav"
   NOTIFICATION_SOUND="mixkit-happy-bell-alert.wav"
   PRETOOLUSE_BLOCK_SOUND="mixkit-happy-bell-alert.wav"
   ERROR_SOUND="mixkit-happy-bell-alert.wav"
   
   # Or use absolute paths to your own WAV files
   STOP_SOUND="/path/to/your/completion-sound.wav"
   ```

### Platform Support

The sound player uses local WAV files for consistent audio across all platforms:

#### macOS
- Uses `afplay` command to play WAV files
- Pre-installed on all macOS systems

#### Windows / WSL
- Uses PowerShell's Media.SoundPlayer to play WAV files
- Works in both native Windows and WSL environments

#### Linux (Native)
- Uses PulseAudio (`paplay`) to play WAV files
- Falls back to ALSA (`aplay`) if PulseAudio is not available

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

## 📚 Feature-Centric Workflow

This repository includes a comprehensive workflow system for managing development with Claude Code. The workflow organizes all work around features, PRDs, and bugs with full session management.

### Workflow Documentation

- **[Workflow Guide](docs/WORKFLOW-GUIDE.md)** - Comprehensive guide to using the feature-centric workflow
- **[Quick Reference](docs/WORKFLOW-QUICKREF.md)** - Command cheat sheet and quick tips

### Key Workflow Commands

- `/setup-workflow` - Initialize the workflow in your project
- `/generate-feature` - Start a new feature with session tracking
- `/generate-prd` - Create a Product Requirements Document
- `/resume` - Continue your most recent work
- `/status` - View all active work
- `/switch [name]` - Switch between different features

### Quick Start

```bash
# First time in a project
/setup-workflow

# Check what's active
/status

# Start new work
/generate-feature "Add user authentication"

# Continue where you left off
/resume
```

The workflow ensures continuity across Claude Code sessions and helps maintain organization in complex projects.

## 📊 Monitoring

### View logs

All logs are stored in the current working directory to keep them contained per Claude instance:

```bash
# Command filter logs (in current directory)
tail -f ./.claude/logs/hooks/command-filter.log

# Hook activity logs (in project directory)
tail -f ./logs/hooks/pre-tool-use.json
tail -f ./logs/hooks/post-tool-use.json
tail -f ./logs/hooks/notification.json

# Parse JSON logs with jq
jq '.[] | select(.tool_name == "Bash")' ./logs/hooks/pre-tool-use.json
jq '.[] | select(.matchedPattern != null)' ./logs/hooks/pre-tool-use.json
```

Log entries include:
- Timestamp
- Tool name and input
- Matched patterns (or `noMatch: true`)
- Decision made (approved/blocked/manual)
- Process information

### Disable logging

You can disable command filter logging by setting `COMMAND_FILTER_LOG_ENABLED="false"` in your `~/.claude/.env` file. This is useful if you want to reduce disk usage or improve performance.

## 🛠️ Customization

### Enable verbose logging

The TypeScript hooks automatically log all activity to JSON files. For additional debugging:

1. Check the command filter logs:
   ```bash
   tail -f ~/.claude/logs/hooks/command-filter.log
   ```

2. View raw hook inputs/outputs:
   ```bash
   jq '.' ./logs/hooks/pre-tool-use.json
   ```

### Modify auto-approval patterns
Edit the JSON configuration files - changes take effect immediately:
- `~/.claude/hooks/ts/command-filter/config/allowed-commands.json`
- `~/.claude/hooks/ts/command-filter/config/blocked-commands.json`

### Disable sound notifications
Set `SOUND_NOTIFICATIONS_ENABLED="false"` in `~/.claude/.env`.

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
claude-code-goodies/
├── README.md
├── CLAUDE.md                    # Claude Code specific instructions
├── LICENSE
├── .env.example                 # Environment configuration template
├── settings.json.example        # Claude Code settings template
├── settings-advanced.json.example # Advanced settings example
├── hooks/
│   └── ts/                      # TypeScript hooks
│       ├── command-filter/     # Command filtering system
│       │   ├── command-filter.ts # Auto-approval/blocking logic
│       │   └── config/          # Configuration files
│       │       ├── allowed-commands.json # Auto-approve patterns
│       │       └── blocked-commands.json # Dangerous command patterns
│       ├── sound-player/        # Sound notification system
│       │   ├── sound-player.ts  # Universal sound player
│       │   └── wav/             # WAV sound files
│       ├── lib/                 # Shared utilities
│       │   ├── types.ts         # TypeScript type definitions
│       │   └── logger.ts        # JSON logging utility
│       └── loggers/             # Logging hooks
│           ├── pre-tool-use.ts  # Log pre-tool-use events
│           ├── post-tool-use.ts # Log post-tool-use events
│           ├── notification.ts  # Log notification events
│           ├── stop.ts          # Log stop events
│           └── subagent-stop.ts # Log subagent-stop events
├── commands/                    # Custom Claude Code commands
│   └── cpr.md                   # Commit, Push, PR command
├── scripts/                     # Installation scripts
│   ├── install-hooks.sh         # Install hooks
│   └── install-commands.sh      # Install custom commands
└── logs/                        # Local log files (gitignored)
    └── hooks/                   # Hook-specific logs
        ├── pre-tool-use.json
        ├── post-tool-use.json
        └── ...
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
- Keep your configuration files private

## 🐛 Troubleshooting

### Hooks not triggering
1. Run `/hooks` in Claude Code to verify they're loaded
2. Check `~/.claude/settings.json` exists and is valid JSON
3. Restart Claude Code completely

### Sound notifications not working

#### macOS
1. Check volume settings are not muted
2. Try playing a sound manually: `afplay /System/Library/Sounds/Glass.aiff`
3. Check the configuration in `~/.claude/.env`

#### Windows / WSL
1. Ensure PowerShell is accessible from your environment
2. Test PowerShell beep: `powershell.exe -c "[Console]::Beep(1000, 300)"`
3. For WSL, ensure Windows interop is enabled
4. Check the configuration in `~/.claude/.env`

#### Linux
1. Check if PulseAudio is running: `pactl info`
2. Test sound playback: `paplay /usr/share/sounds/freedesktop/stereo/complete.oga`
3. Ensure audio permissions are configured correctly
4. Check the configuration in `~/.claude/.env`

### Commands not auto-approving
1. Check the pattern in `allowed-commands.json`
2. Verify regex syntax (use `^` and `$` for exact matches)
3. Check command filter logs: `tail -f ./.claude/logs/hooks/command-filter.log`
4. Ensure the command isn't matching a blocked pattern first
5. Look for the `matchedPattern` field in logs to see what was matched

### WSL-specific issues
1. Ensure bun is installed in the WSL environment, not Windows
2. File paths should use Unix format (`/mnt/c/...` not `C:\...`)
3. Sound notifications require Windows interop to be enabled
4. Use `powershell.exe` instead of `powershell` for sound commands

---

Made with ❤️ for the Claude Code community