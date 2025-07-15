# Claude Code Workflow Commands

This directory contains a comprehensive workflow system designed to help Claude Code maintain context, follow standards, and work effectively on software projects. The workflow implements a "just enough context" principle - providing essential information upfront while loading detailed information only when needed.

## Philosophy

The workflow system addresses key challenges when working with AI coding assistants:
- **Context Management**: Maintains project understanding across sessions
- **Standards Enforcement**: Ensures consistent code quality and patterns
- **Knowledge Persistence**: Documents learnings and decisions
- **Task Organization**: Tracks features, bugs, and ad-hoc tasks systematically

## Workflow Overview

```mermaid
graph LR
    A[New Project] --> B[/setup]
    B --> C[/prime]
    C --> D{Task Type?}
    D -->|Feature| E[/create-prd]
    E --> F[/implement-prd]
    D -->|Research| G[/context]
    D -->|Long Session| H[/refresh]
    F --> I[Session Notes]
    G --> I
    H --> I
```

## Commands

### 🚀 /setup
**Purpose**: Initialize the `.working` directory structure for a new project

**What it does**:
- Creates essential documentation files (PROJECT.md, STANDARDS.md, CODEBASE.md, etc.)
- Analyzes the codebase to understand tech stack and patterns
- Populates templates with project-specific information
- Sets up the foundation for all future work

**Usage**: Run once when starting work on a new project
```
/setup
```

### 📋 /prime
**Purpose**: Load essential project context at the start of each session

**What it does**:
- Establishes 8 core rules for working on the project
- Loads PROJECT.md and STANDARDS.md for essential context
- Checks SESSION-NOTES.md for recent work
- Scans for high-priority tasks and issues
- Implements lazy loading - only reads detailed PRDs when needed

**Usage**: Run at the beginning of every coding session
```
/prime
```

### 📝 /create-prd
**Purpose**: Create a structured Product Requirements Document for new features

**What it does**:
- Asks clarifying questions to understand requirements
- Generates a comprehensive PRD with goals, user stories, and requirements
- Creates implementation task lists with parent/sub-task structure
- Stores PRDs in organized directory structure
- Tracks dependencies between features

**Usage**: When starting a new feature
```
/create-prd Add user authentication system
```

### 🔨 /implement-prd
**Purpose**: Systematically implement a PRD following best practices

**What it does**:
- Loads specific PRD and related context
- Reviews implementation approach before starting
- Updates task checkboxes as work progresses
- Runs tests and validation after implementation
- Maintains session notes automatically

**Usage**: When ready to build a feature
```
/implement-prd
```

### 🔍 /context
**Purpose**: Search across all .working files for specific information

**What it does**:
- Performs efficient searches without loading entire files
- Shows relevant snippets with line numbers
- Suggests which files to read for more detail
- Helps maintain "just enough context" principle

**Usage**: When looking for specific information
```
/context authentication
```

### 🔄 /refresh
**Purpose**: Update context during long sessions

**What it does**:
- Re-reads core files to check for changes
- Identifies updates since last read
- Refreshes understanding without full restart
- Maintains session continuity

**Usage**: During long sessions or when context feels stale
```
/refresh
```

### 🚀 /optimize-claude
**Purpose**: Optimize CLAUDE.md to work efficiently with the workflow system

**What it does**:
- Reduces CLAUDE.md to a minimal bootstrap file
- Preserves only critical security rules
- Creates backup of existing CLAUDE.md
- Reduces token usage by 80-90%
- Delegates all project context to the workflow system

**Usage**: Run once after setting up the workflow
```
/optimize-claude
```

## File Structure

The workflow creates and maintains these files in `.working/`:

```
.working/
├── PROJECT.md        # Project overview, tech stack, features list
├── STANDARDS.md      # Coding standards and conventions
├── CODEBASE.md       # Map of key implementations and patterns
├── LEARNINGS.md      # Technical insights and lessons learned
├── ISSUES.md         # Known bugs and technical debt
├── TASKS.md          # Ad-hoc tasks with priority levels
├── SESSION-NOTES.md  # Automatic session summaries
├── INDEX.md          # Searchable index of key terms
│
└── features/         # PRDs organized by feature
    └── prd-XXXX/
        └── prd-XXXX-feature-name.md
```

## Best Practices

1. **Start Fresh Sessions**: Always run `/prime` when beginning work
2. **Document Features**: Use `/create-prd` for any significant feature
3. **Search First**: Use `/context` before diving into files
4. **Update Regularly**: Keep CODEBASE.md current with major changes
5. **Track Everything**: Use TASKS.md for work outside of PRDs
6. **Archive Completed Work**: Move finished PRDs to archive folder

## Workflow Example

```bash
# Day 1: Starting a new project
/setup                          # Initialize .working structure
/optimize-claude                # Optimize CLAUDE.md for workflow
/prime                          # Load project context
/create-prd Add user auth       # Plan the feature
/implement-prd                  # Build it

# Day 2: Continuing work
/prime                          # Load context + session notes
/context JWT                    # Search for auth implementation
/refresh                        # Update context if needed
```

## Advanced Features

- **Dependency Tracking**: PRDs can specify dependencies on other features
- **Priority Management**: TASKS.md supports [HIGH PRIORITY] flagging
- **Automatic Archival**: Completed work moves to `.working/archive/`
- **Session Continuity**: SESSION-NOTES.md updates automatically during work

## Contributing

When adding new workflow commands:
1. Follow the existing markdown structure
2. Include clear usage examples
3. Integrate with the existing workflow
4. Update this README