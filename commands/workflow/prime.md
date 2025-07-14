# Prime Project Context

You are about to work on a project. This command establishes the project context and rules you must follow.

## Project Rules

These rules are critical and must be followed at all times when working on this project:

1. **Understand the project context**
   - Read the PROJECT.md file in the /.working directory to understand the project overview, tech stack, and constraints
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

4. **Track issues**
   - When discovering project issues, check ISSUES.md first
   - If the issue is not already documented, add it to ISSUES.md
   - Include details about the issue, potential impact, and suggested fixes

5. **DO NOT make assumptions**
   - Do not assume unstated requirements
   - Do not introduce new architectural patterns
   - Do not add features beyond what's explicitly requested
   - Ask for clarification when requirements are unclear

## Expected Directory Structure

The project should maintain this structure:

```
/working/
│
├── PROJECT.md        # Core project info, tech stack, features list
├── STANDARDS.md      # Development standards and git discipline
├── LEARNINGS.md      # Documented missteps and technical insights
├── ISSUES.md         # Known issues, bugs, and regressions
├── TASKS.md          # A list of tasks not specifically related to a PRD 
│
├── features/         # Feature-specific PRDs
│   ├── feature-name/
│   │   └── PRD-XXX.md
│   └── ...
│
└── prime.md          # This priming document
```

## Actions to take now:

1. First, check if the /.working directory exists and has the required files
2. Read PROJECT.md to understand the current project
3. Read STANDARDS.md to understand coding standards
4. Familiarize yourself with any existing issues in ISSUES.md
5. Confirm you understand and will follow all the rules stated above

Remember: These rules override any default behaviors. Always refer back to these guidelines throughout your work on this project.
