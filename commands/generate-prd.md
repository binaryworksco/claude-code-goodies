# /generate-prd <Feature> - Create Product Requirements Document in Markdown

<command_overview>
Creates a Product Requirements Document (PRD) as a new markdown file based on a feature idea stated in <feature_description/> and store it in <prd_storage_location/>. The PRD will be clear, actionable, and suitable for a junior developer to understand and implement.
</command_overview>

<usage>
/generate-prd <feature_description/>

Example:
/generate-prd Add ability to export contacts to CSV
</usage>

<feature_description>$ARGUMENTS</feature_description>

<prd_number>
Every PRD is given a number, if there are no files in the ./docs/prd folder, the first PRD number is 0001. For every new PRD generated, increment the prd-number by 1.

Pad the PRD number with 0 to be 4 digits.
</prd_number>

<prd_storage_location>
./docs/prd/prd-[prd-number]-[feature name].md

Example:
./docs/prd/prd-0005-authentication.md
</prd_storage_location>

<process>

## Step 1: Receive Feature Description
The user provides a brief description or request for a new feature or functionality via the command parameter.

## Step 2: Understand Project Context
Read any documentation within the solution (README.md, CLAUDE.md, /docs folder etc...) and make sure you fully understand the context of the project. Take this into consideration for the future steps.

## Step 3: Ask Clarifying Questions
Before writing the PRD, ask clarifying questions to gather sufficient detail. The goal is to understand the "what" and "why" of the feature, not necessarily the "how" (which the developer will figure out).

<clarifying_questions>
## Example Clarifying Questions
The AI should adapt its questions based on the prompt, but here are some common areas to explore:

- **Problem/Goal:** "What problem does this feature solve for the user?" or "What is the main goal we want to achieve with this feature?"
- **Target User:** "Who is the primary user of this feature?"
- **Core Functionality:** "Can you describe the key actions a user should be able to perform with this feature?"
- **User Stories:** "Could you provide a few user stories? (e.g., As a [type of user], I want to [perform an action] so that [benefit].)"
- **Acceptance Criteria:** "How will we know when this feature is successfully implemented? What are the key success criteria?"
- **Scope/Boundaries:** "Are there any specific things this feature *should not* do (non-goals)?"
- **Data Requirements:** "What kind of data does this feature need to display or manipulate?"
- **Design/UI:** "Are there any existing design mockups or UI guidelines to follow?" or "Can you describe the desired look and feel?"
- **Edge Cases:** "Are there any potential edge cases or error conditions we should consider?"
</clarifying_questions>

## Step 4: Generate PRD
Based on the initial prompt, your understanding of the context of the project and the user's answers to the clarifying questions, generate a PRD using the structure below.

## Step 5: Create Markdown File
Create the PRD as a markdown and save it to <prd_storage_location>.

## Step 6: Generate Tasks (After PRD Review)
Once the user has reviewed and approved the PRD, proceed with task generation:

1. **Phase 1: Generate Parent Tasks**
   - Analyze the PRD to identify high-level tasks
   - Present these parent tasks to the user
   - Inform the user: "I have generated the high-level tasks based on the PRD. Ready to generate the detailed sub-tasks? Respond with 'Go' to proceed."

2. **Wait for Confirmation**
   - Pause and wait for the user to respond with "Go"

3. **Phase 2: Generate Sub-Tasks**
   - Break down each parent task into smaller, actionable sub-tasks
   - Add these as a checklist within the PRD issue body
   - Each sub-task should be specific and implementable

4. **Update PRD with Task List**
   - Edit the PRD issue to include the complete task checklist
   - Tasks will be tracked as checkboxes within the PRD
   - Claude will update these checkboxes as tasks are completed during implementation
   - The first task should always be to create a new branch for this feature

5. **Commit PRD**
   - Ask the user to review the PRD and ask them if they are okay to commit this PRD
   - Always perform the commit on the new branch that is defined in the PRD

Do not include things like man-day estimates or project planning guides (example: Week 1, Week 2 etc...)
</process>

<prd_structure>

## PRD Structure

The generated PRD should include the following sections:

1. **Introduction/Overview:** Briefly describe the feature and the problem it solves. State the goal.

2. **Goals:** List the specific, measurable objectives for this feature.

3. **User Stories:** Detail the user narratives describing feature usage and benefits.

4. **Functional Requirements:** List the specific functionalities the feature must have. Use clear, concise language (e.g., "The system must allow users to upload a profile picture."). Number these requirements.

5. **Non-Goals (Out of Scope):** Clearly state what this feature will *not* include to manage scope.

6. **Design Considerations (Optional):** Link to mockups, describe UI/UX requirements, or mention relevant components/styles if applicable.

7. **Technical Considerations (Optional):** Mention any known technical constraints, dependencies, or suggestions (e.g., "Should integrate with the existing Auth module").

8. **Success Metrics:** How will the success of this feature be measured? (e.g., "Increase user engagement by 10%", "Reduce support tickets related to X").

9. **Open Questions:** List any remaining questions or areas needing further clarification.

10. **Implementation Tasks:** Task checklist that will be added after PRD approval (tasks tracked within this PRD, not as separate issues).

</prd_structure>

<target_audience>
## Target Audience

Assume the primary reader of the PRD is a **junior developer**. Therefore:
- Requirements should be explicit and unambiguous
- Avoid jargon where possible
- Provide enough detail for them to understand the feature's purpose and core logic
- Include examples where helpful
</target_audience>

<implementation_notes>

## Implementation Notes for Claude

1. Parse the feature description from the command parameter
2. Ask clarifying questions based on the feature description
3. Wait for user responses before generating the PRD
4. Do NOT start implementing the PRD
5. Create the PRD as a markdown file
6. After creating the PRD, ask: "Would you like me to generate the implementation tasks for this PRD?"
7. If user confirms, follow the two-phase task generation process:
   - Phase 1: Generate and show parent tasks, wait for "Go"
   - Phase 2: Generate sub-tasks and update the PRD issue with the complete task checklist
8. During implementation, always update task checkboxes as work progresses in the markdown

</implementation_notes>

<example_workflow>

## Example Workflow

User: `/prd Add customer email notification preferences`

Claude:
01. Acknowledges the feature request
02. Asks clarifying questions about notification types, delivery methods, user control, etc.
03. Waits for user responses
04. Generates comprehensive PRD based on responses
05. Creates markdown file with PRD content
06. Asks: "Would you like me to generate the implementation tasks for this PRD?"

If user says yes:
07. Generate parent tasks and presents them
08. Waits for user to say "Go"
09. Generates detailed sub-tasks
10. Updates the PRD issue to include the complete task checklist
11. Asks the user if they are happy with this PRD and want to commit it for safe keeping
12. During implementation, Claude updates checkboxes as tasks are completed

</example_workflow>

<task_structure>

## Task Structure Format

When generating tasks, follow this structure:

### Parent Tasks (Phase 1)
```
1.0 Database Schema and Models
2.0 Backend API Implementation  
3.0 Frontend UI Components
4.0 Integration and Testing
5.0 Documentation and Deployment
```

### Complete Task List (Phase 2)
```markdown
## Implementation Tasks

### 1.0 Database Schema and Models
- [ ] Design notification preferences table schema
- [ ] Create Entity Framework models
- [ ] Generate database migrations
- [ ] Add repository interfaces and implementations

### 2.0 Backend API Implementation
- [ ] Create notification service interface
- [ ] Implement email notification logic
- [ ] Add API endpoints for preference management
- [ ] Implement notification queuing system

### 3.0 Frontend UI Components
- [ ] Create notification settings page
- [ ] Build preference toggles component
- [ ] Add notification preview section
- [ ] Implement save/cancel functionality

(Additional tasks as needed...)
```

All tasks are tracked as checkboxes within the PRD markdown. Claude will update the markdown checkboxes during implementation.

</task_structure>