# Development Workflow

This document describes the feature-centric workflow used in this project. All work is organized around features, PRDs, and bugs, with each having its own folder containing all related artifacts.

## Workflow Overview

When you are given a task, always do the following:

### 1. Check for Active Sessions
First, look for active work by checking session.md files in:
- `/docs/features/*/session.md` - Active features
- `/docs/prd/*/session.md` - Active PRDs
- `/docs/bugs/*/session.md` - Active bugs

Use the `/status` command to see all active work, or `/resume` to continue the most recent session.

### 2. Load Essential Context
- Read `/docs/QUICKSTART.md` for essential project information (always < 500 lines)
- Check `/docs/LESSONS.md` for project-specific patterns and gotchas
- If resuming work, load the relevant `session.md` file from the feature/PRD/bug folder

### 3. Identify Task Type
Determine what kind of work is being requested:
- **bug-fix**: Quick fixes, use `/docs/bugs/` structure
- **feature**: Implementation work, use `/docs/features/` structure  
- **prd**: Major features needing planning, use `/docs/prd/` structure
- **research**: Information gathering, may not need session tracking

### 4. Create or Update Session
For new work:
- Use `/generate-feature` for features
- Use `/generate-prd` for major features requiring planning
- Use `/report-bug` for bug fixes
- These commands create the folder structure and initialize session tracking

For existing work:
- Update the `session.md` file with current progress
- Log decisions in `decisions.md`
- Keep working notes in `notes.md`

### 5. Load Relevant Documentation
Based on task type, selectively load:
- Technical docs from `/docs/tech/` for coding tasks
- Style guides from `/docs/style/` for UI tasks
- Architecture docs for system design tasks
- Only load what's needed to avoid token overload

### 6. Clarify and Align
- Ask clarifying questions based on gaps in understanding
- Summarize your understanding before starting implementation
- Update session.md with the agreed approach

### 7. Track Progress
Throughout your work:
- Update task checkboxes in the feature/PRD document
- Keep `session.md` current with status
- Log important decisions in `decisions.md`
- Use `notes.md` for temporary information

## Session Management Commands

### Starting Work
- `/generate-feature "Feature description"` - Start a new feature
- `/generate-prd "Major feature description"` - Start a PRD
- `/report-bug "Bug description"` - Report and start fixing a bug

### Continuing Work
- `/resume` - Resume the most recent session
- `/switch-feature [name]` - Switch to a different active feature
- `/status` - See all active work

### Example Session Flow
```
User: "I need to add user authentication"

Claude: I'll help you add user authentication. Let me check for any active sessions first.
[Runs /status internally]

No active sessions found. This seems like a substantial feature. Would you like me to:
1. Create a PRD for planning (recommended for auth systems)
2. Create a feature for immediate implementation

User: Let's do a PRD

Claude: [Runs /generate-prd "User authentication system"]
[Creates /docs/prd/prd-0001-authentication/]
[Initializes session.md, decisions.md, notes.md]
[Asks clarifying questions about auth requirements]
```

## Multi-Agent Coordination

When spawning subagents:
1. Create agent session files in the feature's `agents/` subdirectory
2. Name them descriptively: `search-patterns-01.md`, `run-tests-01.md`
3. Update main `session.md` with agent activities
4. Coordinate through the parent session file

Example structure:
```
/docs/features/feature-0005-authentication/
├── feature-0005-authentication.md
├── session.md                    # Main session
├── decisions.md
├── notes.md
└── agents/
    ├── search-patterns-01.md     # Subagent searching for patterns
    └── test-runner-01.md         # Subagent running tests
```

## Best Practices

1. **Keep sessions focused**: One feature/PRD/bug per session
2. **Update frequently**: Keep session.md current as you work
3. **Document decisions**: Use decisions.md for important choices
4. **Clean up notes**: Periodically clean notes.md of outdated information
5. **Complete the cycle**: Mark sessions as "Completed" when done
6. **Archive regularly**: Move completed work to `/docs/archive/YYYY-QX/`