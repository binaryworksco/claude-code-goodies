# CLAUDE.md

This project uses a structured workflow system for context management.

## Required: Start Every Session
```
/workflow:prime
```

This command loads project context, standards, and recent work from the .working directory.

## Available Commands
- `/workflow:help` - View all workflow commands
- `/workflow:context <term>` - Search project information
- `/workflow:refresh` - Update context during long sessions

## Project Documentation
All project-specific information is maintained in:
- `.working/PROJECT.md` - Project overview and features
- `.working/STANDARDS.md` - Coding standards
- `.working/CODEBASE.md` - Key implementation locations

## Security Considerations
- All hooks execute with user permissions
- Blocked patterns are checked before allowed patterns
- Sensitive files are explicitly blocked (`.env`, `.ssh`, etc.)
- Logs are stored locally and gitignored

---
Note: This file is intentionally minimal. Use the workflow system for detailed project information.