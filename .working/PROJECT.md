# Project Documentation

**Last Updated:** 2025-07-17

## Project Overview
Claude Code Goodies is a community-driven enhancement system for Claude Code that provides auto-approval of safe operations, sound notifications, and custom workflow commands. The project delivers TypeScript-based hooks that integrate with Claude Code's hooks system to improve developer workflow efficiency while maintaining security through whitelist-based approval patterns.

## Tech Stack
- **Programming Languages**: TypeScript, Shell (Bash)
- **Runtime**: Bun (TypeScript execution)
- **Frameworks/Libraries**: None (minimal dependencies)
- **Audio**: Native platform audio players (afplay, paplay, PowerShell)
- **Build Tools**: None required (direct TypeScript execution)
- **Testing**: Manual testing via command execution
- **Version Control**: Git with GitHub integration
- **Deployment**: Local installation via shell scripts

## Special Considerations & Constraints
- **Claude Code Integration**: Requires Claude Code to be installed and properly configured
- **Cross-Platform Support**: Must work on macOS, Windows (via WSL), and Linux
- **Security**: Whitelist-based approval system with dangerous command blocking
- **Performance**: Hooks must execute quickly to avoid blocking Claude Code operations
- **Dependencies**: Minimal external dependencies to ensure reliability
- **Configuration**: User settings stored separately from code to preserve during updates
- **Logging**: Dual logging approach (user directory and project directory)
- **Sound Files**: WAV format for universal platform compatibility

## Product Requirements Documents (PRDs)
| Feature | Status | PRD Link | Description | Dependencies | 
|---------|--------|----------|-------------|--------------|
| Command Auto-Approval | Completed | [Implementation](../hooks/ts/command-filter/) | Auto-approve safe operations based on patterns | None |
| Sound Notifications | Completed | [Implementation](../hooks/ts/sound-player/) | Play sounds for different Claude Code events | None |
| Activity Logging | Completed | [Implementation](../hooks/ts/loggers/) | JSON logging of all hook activities | None |
| Custom Commands | Completed | [Implementation](../commands/) | Workflow automation commands like /cpr | None |
| Workflow System | In Progress | [Implementation](../commands/workflow/) | Structured project management workflow | None |

### PRD Dependency Graph
```
Core Hook System
├── Command Auto-Approval → Activity Logging
├── Sound Notifications → Activity Logging
└── Custom Commands → Workflow System
```