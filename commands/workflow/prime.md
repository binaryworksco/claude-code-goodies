# Prime Project Context

You are about to work on a project. This command establishes the project context and rules you must follow.

## Workflow Structure

Ensure that the .working folder is present in the root of the project and PROJECT.md and STANDARDS.md files are available. If the folder or files are not present, stop processing the rest of the commands in this document and instruct the user to run the `/setup` command.

## Project Rules

These rules are critical and must be followed at all times when working on this project:

1. **Understand the project context**
   - Read the PROJECT.md file in the .working directory to understand the project overview, tech stack, and constraints
   - Review the list of features/PRDs to familiarize yourself with the project scope (don't read individual PRDs unless needed for a specific task)

2. **Follow coding standards**
   - Read and enforce the project coding standards defined in STANDARDS.md
   - Maintain consistency with existing code patterns and conventions
   - Do not introduce new patterns unless explicitly instructed

3. **Verify your work**
   - After completing any task, review your implementation against requirements
   - Ensure compliance with project guidelines and standards
   - If work needs to be redone, document lessons learned in LEARNINGS.md
   - Repeat verification until the task is properly completed

4. **Track ad-hoc tasks**
   - Record ad-hoc tasks (not tied to specific PRDs) in TASKS.md
   - Use the standard task format with checkboxes
   - Update task items to [x] when completed
   - Even single-item tasks should use checkbox format

5. **Track issues**
   - When discovering project issues, check ISSUES.md first
   - If the issue is not already documented, add it to ISSUES.md
   - Include details about the issue, potential impact, and suggested fixes

6. **DO NOT make assumptions**
   - Do not assume unstated requirements
   - Do not introduce new architectural patterns
   - Do not add features beyond what's explicitly requested
   - Ask for clarification when requirements are unclear

7. **Maintain session continuity**
   - Check SESSION-NOTES.md for recent context (if it exists)
   - Throughout your work, update SESSION-NOTES.md when:
     - Completing significant features or fixes
     - Making important technical decisions
     - Before ending a session or switching contexts
   - Keep one entry per session date, updating it as work progresses
   - Format: concise 2-3 sentences capturing what was accomplished

## Task Tracking Format

For ad-hoc tasks that fall outside of PRDs, document them in TASKS.md using this format:

```
**Task Name** - Date: [Date Started]
[Short Description]
[ ] Task Item 1
[ ] Task Item 2
[ ] Task Item 3
```

Guidelines:
- Update checkboxes to [x] as items are completed
- Even single-item tasks should use the checkbox format
- Keep descriptions concise and action-oriented
- Group related tasks together when possible

## Session Notes Format

Maintain session notes in .working/SESSION-NOTES.md:

```
## [Current Date and Time]
[2-3 sentence summary of work completed/in progress]
```

Update the current date's entry as work progresses. Each date should have only one entry.

## Expected Directory Structure

The project should maintain this structure:

```
.working/
│
├── PROJECT.md        # Core project info, tech stack, features list
├── STANDARDS.md      # Development standards and git discipline
├── LEARNINGS.md      # Documented missteps and technical insights
├── ISSUES.md         # Known issues, bugs, and regressions
├── TASKS.md          # A list of tasks not specifically related to a PRD
├── SESSION-NOTES.md  # Rolling summary of work sessions 
│
└── features/         # Feature-specific PRDs
    ├── feature-name/
    │   └── PRD-XXX.md
    └── ...
```

## Actions to take now:

1. First, check if the .working directory exists and has the required files
2. Read PROJECT.md to understand the current project
3. Read STANDARDS.md to understand coding standards
4. Check SESSION-NOTES.md for recent work context (last 3-5 entries if it exists)
5. Familiarize yourself with any existing issues in ISSUES.md
6. Confirm you understand and will follow all 7 rules stated above by giving a short summary.

Remember: These rules override any default behaviors. Always refer back to these guidelines throughout your work on this project.
