# Implement Product Requirements Document

<command_overview>
Implements a Product Requirements Document (PRD) from the .working/features directory following enterprise development practices. The command takes a PRD number, confirms the correct PRD with the user, then guides development through the task checklist while maintaining review checkpoints and updating progress.
</command_overview>

<usage>
/implement-prd <prd_number/>

Example:
/implement-prd 5
</usage>

<prd_number>
#$ARGUMENTS
</prd_number>

<process>

## Step 1: Locate and Confirm PRD
1. Search .working/features/ directory for folder matching pattern: prd-[prd_number]
2. Read the PRD's Introduction/Overview section from the markdown file in the folder
3. Extract the feature name from the filename
4. Present confirmation to user:
    - **PRD Number:** [prd_number]
    - **Feature Name:** [extracted from filename]
    - **Description:** [brief summary from Introduction/Overview]
5. Ask: "Is this the correct PRD you want to implement? (Yes/No)"
6. Wait for user confirmation before proceeding

## Step 2: Setup Development Environment
1. Ensure that the prime.md command has been run and you fully understand the project and standards.
2. Create feature branch: `feature/prd-[prd_number]-[feature-name]`
3. Display the Implementation Tasks checklist from the PRD

## Step 3: Task-Driven Development
1. Work through tasks systematically, starting with parent task 1.0
2. For each sub-task:
    - Implement the functionality
    - Update PRD markdown by changing [ ] to [x]
    - Save the PRD file
3. Follow enterprise development standards:
    - Proper error handling and logging
    - Security best practices
    - SOLID principles
    - XML documentation comments
    - Unit tests for critical functionality
4. As you complete each sub-task, update the sub-task markdown from [ ] to [x]

## Step 4: Review Checkpoints
After completing each parent task (e.g., all sub-tasks under 1.0):
1. Display message: "This would be a good time to take a minute and review what we have done so far. Please review the changes and let me know if you would like me to commit the code or make any adjustments."
2. Show completed tasks from the PRD
3. Wait for explicit user approval
4. Only proceed after user consent

## Step 5: Commit Process
1. After user approval at checkpoint:
    - Commit with format: `feat(prd-[number]): Complete [parent task name]`
    - Include list of completed sub-tasks in commit body
2. Continue with next parent task

</process>

<implementation_guidelines>

## Architecture Compliance
- Read and follow patterns defined in CLAUDE.md
- Use established project conventions
- Maintain consistency with existing codebase

## Task Management
- The PRD's Implementation Tasks section is the source of truth
- Update checkboxes in real-time as work progresses
- Each parent task (1.0, 2.0, etc.) represents a logical unit of work
- Complete all sub-tasks within a parent before moving to the next

## Code Quality Standards
- Write self-documenting code with clear variable names
- Add comprehensive error handling
- Include appropriate logging statements
- Follow security best practices
- Implement unit tests for business logic
- Use dependency injection where appropriate

## Review Checkpoint Format
```
=== REVIEW CHECKPOINT ===
Parent Task Completed: 1.0 Database Schema and Models

Completed Sub-tasks:
✓ Design notification preferences table schema
✓ Create Entity Framework models  
✓ Generate database migrations
✓ Add repository interfaces and implementations

This would be a good time to take a minute and review what we have done so far. 
Please review the changes and let me know if you would like me to commit the code or make any adjustments.
```

</implementation_guidelines>

<error_handling>

## Common Scenarios

### PRD Not Found
If no PRD matches the provided number:
- List available PRDs in ./docs/prd/
- Ask user to verify the PRD number

### Multiple PRDs Match
If multiple files match the pattern:
- List all matching PRDs
- Ask user to specify which one

### Missing Implementation Tasks
If PRD lacks Implementation Tasks section:
- Alert user that tasks are missing
- Suggest running task generation first

### Architecture File Missing
If CLAUDE.md is not found:
- Proceed with general best practices
- Alert user that architecture guidelines are missing

</error_handling>

<workflow_example>

## Example Workflow

User: `/implement-prd 5`

Claude:
1. Searches .working/features/ and finds prd-005/prd-005-payroll-module.md
2. Reads the PRD and presents:
   ```
   Found PRD #5
   Feature Name: Payroll Module
   Description: Implement a comprehensive payroll processing system that calculates employee wages, 
                handles tax deductions, and generates pay stubs.
   
   Is this the correct PRD you want to implement? (Yes/No)
   ```
3. User confirms: "Yes"
4. Creates branch: `feature/prd-0005-payroll-module`
5. Shows Implementation Tasks from PRD
6. Begins with task 1.0, implementing each sub-task
7. Updates PRD checkboxes as tasks complete
8. After 1.0 completion, shows review checkpoint
9. User approves, Claude commits
10. Continues with task 2.0

</workflow_example>

<commit_message_format>

## Commit Message Standards

```
feat(prd-[number]): Complete [Parent Task Name]

Completed sub-tasks:
- [Sub-task 1 description]
- [Sub-task 2 description]
- [Sub-task 3 description]

PRD: .working/features/prd-[number]/prd-[number]-[feature-name].md
```

Example:
```
feat(prd-109): Complete Database Schema and Models

Completed sub-tasks:
- Design payroll tables schema
- Create Entity Framework models
- Generate database migrations
- Add repository interfaces and implementations

PRD: .working/features/prd-109/prd-109-payroll-module.md
```

</commit_message_format>