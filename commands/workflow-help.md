# Workflow Help

## Available Workflow Commands

Here's a quick guide to the workflow commands that help me work effectively on your project:

### 🚀 `/setup` - Initialize Project Workflow
Sets up the `.working` directory with all necessary documentation files. Run this once when starting work on a new project. It analyzes your codebase and creates PROJECT.md, STANDARDS.md, CODEBASE.md, and other tracking files.

### 📋 `/prime` - Start a Session
Loads essential project context at the beginning of each work session. This gives me just enough information to work effectively without overwhelming my context. Always run this when we start working together.

### 📝 `/create-prd` - Plan a Feature
Creates a Product Requirements Document for new features. I'll ask clarifying questions, then generate a comprehensive PRD with user stories, requirements, and task lists.
```
Usage: /create-prd <feature description>
```

### 🔨 `/implement-prd` - Build a Feature
Systematically implements a PRD. I'll review the requirements, implement the feature step-by-step, update task checkboxes, and run tests.

### 🔍 `/context` - Search Project Info
Searches across all .working files to find specific information without loading entire files. Great for finding previous decisions, patterns, or implementations.
```
Usage: /context <search term>
```

### 🔄 `/refresh` - Update Context
Refreshes my understanding during long sessions. Re-reads core files and identifies any changes since last read.

### 🚀 `/optimize-claude` - Optimize CLAUDE.md
Creates a minimal CLAUDE.md that works efficiently with the workflow system. Reduces token usage by ~85% while preserving critical rules. Run once after setting up the workflow.

## Typical Workflows

**Starting a new project:**
```
/setup      → /optimize-claude → /prime      → ready to work!
```

**Building a new feature:**
```
/prime      → /create-prd → /implement-prd
```

**Researching existing code:**
```
/prime      → /context <topic>
```

**Long working session:**
```
/prime      → work... → /refresh → continue working
```

## Key Files I Maintain

- **PROJECT.md** - Project overview and feature list
- **STANDARDS.md** - Coding standards to follow
- **CODEBASE.md** - Map of important code locations
- **SESSION-NOTES.md** - Automatic work summaries
- **TASKS.md** - Ad-hoc tasks and priorities
- **ISSUES.md** - Known bugs and problems

## Tips for Success

1. Always `/prime` at the start of our session
2. Use `/create-prd` for any significant feature
3. Let me update SESSION-NOTES.md automatically
4. Search with `/context` before asking me to read files
5. Refresh during long sessions with `/refresh`

Need more details? Check out the workflow README on GitHub!