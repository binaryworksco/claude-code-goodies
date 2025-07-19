# Development Standards

## Code Style
- **Formatting**: Use consistent indentation (2 spaces)
- **Line Length**: Max 120 characters per line
- **Comments**: Write clear, concise comments for complex logic only
- **Linting**: TypeScript files should follow standard TS conventions
- **Shebang**: TypeScript executables start with `#!/usr/bin/env bun`

## Naming Conventions
- **Variables**: camelCase (e.g., `configPath`, `matchedPattern`)
- **Constants**: UPPER_SNAKE_CASE or PascalCase for configs
- **Classes/Interfaces**: PascalCase (e.g., `PreToolUseInput`, `CommandsConfig`)
- **Files**: kebab-case for files (e.g., `command-filter.ts`, `sound-player.ts`)
- **Functions**: Descriptive camelCase verbs (e.g., `readStdin`, `loadBlockedCommands`)
- **Types**: PascalCase for type definitions and interfaces

## Architecture Standards
- **Structure**: Modular design with shared utilities in `lib/` directories
- **Separation**: Keep hook logic separate from configuration
- **Dependencies**: Minimal external dependencies (only Node.js built-ins)
- **Patterns**: Event-driven hook architecture, JSON-based configuration
- **Configuration**: User settings in `~/.claude/`, code in repository
- **Logging**: Structured JSON logging for easy parsing

## Git Discipline
- **Commits**: Conventional commits (feat:, fix:, refactor:, chore:)
- **Branches**: feature/*, fix/*, refactor/* naming
- **PR Size**: Keep PRs focused on single features or fixes
- **Reviews**: All code requires review before merge
- **Messages**: Clear, descriptive commit messages explaining the "why"

## Testing
- **Coverage**: Manual testing via command execution
- **Types**: Test hooks with various inputs and edge cases
- **Running**: Use test commands documented in README
- **Validation**: Ensure hooks don't break Claude Code functionality

## Documentation
- **Code**: Self-documenting code with TypeScript types
- **APIs**: Document hook input/output formats
- **README**: Comprehensive setup and usage instructions
- **File Size**: Keep documentation files under 500 lines for maintainability
- **Session Notes**: Update SESSION-NOTES.md proactively during significant work
- **Codebase Map**: Update CODEBASE.md when adding major features or changing patterns
- **Examples**: Provide clear examples for all configurations

## Security Standards
- **Whitelist Approach**: Default deny, explicit allow for commands
- **Pattern Validation**: Test regex patterns thoroughly
- **No Secrets**: Never commit API keys, tokens, or credentials
- **User Permissions**: Hooks run with user permissions only
- **Configuration**: Keep dangerous patterns in blocked lists

## Hook Development
- **Input Validation**: Always validate stdin JSON input
- **Error Handling**: Graceful failures with informative messages
- **Performance**: Hooks must execute quickly (< 100ms)
- **Exit Codes**: Use proper exit codes (0 for success)
- **Cross-Platform**: Test on macOS, Linux, and WSL

## Archival Process
- **Completed Features**: Document in PROJECT.md
- **Old Versions**: Keep legacy hooks for compatibility
- **Cleanup**: Remove unused code after deprecation period
- **Timing**: Review and clean up quarterly