# Context Initialization Protocol

**Before starting any task, follow this context loading procedure:**

## Step 1: Required Reading
Always begin by reading these two files in order:
1. `@docs/agent-context/about.md` - Project overview and architecture
2. `@docs/agent-context/index.md` - Context documentation directory

## Step 2: Selective Context Loading
Based on the task requirements and the guidance in `index.md`:
- Identify which context documents are relevant to your current task
- Read ONLY the relevant documents from `@docs/agent-context/`
- Skip any documents unrelated to the task to preserve context window capacity

## Step 3: Adaptive Context Expansion
During planning or implementation:
- If you encounter areas requiring additional context, pause your work
- Return to `@docs/agent-context/index.md` to identify the appropriate documentation
- Load only the specific additional context files needed
- Resume your task with the expanded knowledge

**Important:** This selective loading approach ensures optimal use of context window while maintaining access to all necessary project information. Do not preemptively load all documentation - load only what the current task demands.

**Important:** Make sure you always follow the specified coding standards and guidelines as specified in 'agent-os'. If you are unclear about the standards and guidelines, inform the user before starting any work.

## Prime Command Output

After loading the relevant context documents, provide the following confirmation:

## 1. Project Summary
Present a concise overview (2-3 sentences) covering:
- Project purpose and core functionality
- Primary technology stack
- Current development focus or status

## 2. Context Manifest
List all documents currently loaded in context, organized by category:

### Core Context Files
- `about.md` - Project overview
- `index.md` - Documentation directory
- [Additional files from `@docs/agent-context/`]

### System Files (if applicable)
- Include any 'agent-os' or system configuration files
- Framework or tooling configuration files

**Format Example:**
```
Context loaded for: [Task Description]
Files in context (7 total):
- docs/agent-context/about.md
- docs/agent-context/index.md
- docs/agent-context/database-architecture.md
- docs/agent-context/module-architecture.md
- .agent-os/product/roadmap.md
- ~/.agent-os/standards/code-style.md
- .env.example
```

This manifest ensures full transparency about which information is available for the current task.

**Important:** Explicitly list the exact files that have been read into context, including the full file path