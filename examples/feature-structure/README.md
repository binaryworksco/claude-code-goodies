# Example Feature Structure

This directory demonstrates the feature-centric workflow structure where all artifacts related to a feature are stored together.

## Structure Overview

```
feature-0001-user-authentication/
├── feature-0001-user-authentication.md  # Main feature document with requirements and tasks
├── session.md                           # Current session state and progress tracking
├── decisions.md                         # Important decisions made during development
├── notes.md                            # Temporary working notes and research
└── agents/                             # Multi-agent session files
    └── search-patterns-01.md           # Example subagent session
```

## Key Concepts

### Feature Document
The main `.md` file contains:
- Feature overview and goals
- Requirements (functional and non-functional)
- Task checklist with completion tracking
- Technical approach
- Success criteria

### Session Management
`session.md` tracks:
- Current status and focus
- Completed vs pending tasks
- Branch information
- Key decisions reference
- Next steps
- Multi-agent activity log

### Decision Tracking
`decisions.md` documents:
- Architectural decisions with context
- Options considered with pros/cons
- Rationale for choices made
- Impact on implementation

### Working Notes
`notes.md` contains:
- Temporary research notes
- Code snippets for reference
- TODOs that don't fit in main tasks
- Questions for the team
- Debugging observations

### Agent Coordination
The `agents/` folder contains:
- Individual session files for subagents
- Task-specific agent work
- Results that feed back to main session

## Benefits

1. **Everything Together**: All feature-related content in one place
2. **Easy Handoff**: New developers can understand full context
3. **Clear History**: Decisions and progress are well documented
4. **Multi-Agent Ready**: Structure supports parallel work
5. **Simple Archival**: Just move the folder when complete

## Usage

1. Start a feature: `/generate-feature "feature description"`
2. Work on tasks, updating session.md as you go
3. Document decisions in decisions.md
4. Use notes.md for temporary information
5. When complete, archive the entire folder

This structure ensures work continuity across Claude Code sessions and makes it easy to resume or hand off work.