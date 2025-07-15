---
allowed-tools: Read, Bash(test:*)
description: Load project context and establish workflow rules
---

# Prime Project Context

## Workflow Structure Verification

- Working directory check: !`test -d .working && echo "✓ .working directory found" || echo "✗ .working directory not found"`
- PROJECT.md check: !`test -f .working/PROJECT.md && echo "✓ PROJECT.md found" || echo "✗ PROJECT.md missing"`
- STANDARDS.md check: !`test -f .working/STANDARDS.md && echo "✓ STANDARDS.md found" || echo "✗ STANDARDS.md missing"`

## Your Task

If any of the above checks show missing files (✗), stop processing and inform the user:
"The .working directory or required files are missing. Please run the `/setup` command to initialize the workflow structure."

Otherwise, proceed to establish the project context and rules.

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

8. **Use the codebase map**
   - Consult CODEBASE.md for key implementation locations before searching
   - Update CODEBASE.md when:
     - Adding major new features or components
     - Changing architectural patterns
     - Discovering important implementation details
   - For specific implementations not in CODEBASE.md, use search tools

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
├── CODEBASE.md       # Map of key implementation locations and patterns
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

1. Review the verification results above
2. If all required files exist, read PROJECT.md to understand the current project
3. Read STANDARDS.md to understand coding standards
4. Check CODEBASE.md for key implementation locations (if it exists)
5. Check SESSION-NOTES.md for recent work context (last 3-5 entries if it exists)
6. Scan TASKS.md for any [HIGH PRIORITY] items without reading all details
7. Note the number of open issues in ISSUES.md without reading all details
8. Provide the standardized response below confirming understanding

Remember: These rules override any default behaviors. Always refer back to these guidelines throughout your work on this project.

## Response Format

After completing all actions above, provide this standardized response:

```
✅ Project Context Loaded

**Project**: [Name from PROJECT.md]
**Type**: [Application type from PROJECT.md overview]
**Tech Stack**: [Primary technologies from PROJECT.md]

**Workflow Rules Acknowledged**:
1. ✓ Project context understood
2. ✓ Coding standards loaded
3. ✓ Work verification process clear
4. ✓ Task tracking format understood
5. ✓ Issue tracking process clear
6. ✓ No assumptions policy acknowledged
7. ✓ Session continuity practices understood
8. ✓ Codebase map consulted

**Recent Context**: [Brief summary from SESSION-NOTES.md or "No recent sessions found"]
**Priority Items**: [Number of HIGH PRIORITY tasks or "None identified"]
**Open Issues**: [Count from ISSUES.md, e.g., "3 open issues noted"]

Ready to proceed with development following the established workflow.
```

Customize the response with actual values from the files you've read, but maintain this exact format for consistency.
