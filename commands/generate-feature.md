# /generate-feature <Feature> - Create Feature Document in Markdown

<command_overview>
Creates a concise feature document as a markdown file based on a feature idea. The document includes a brief overview, goals, and implementation tasks. This is a lightweight alternative to full PRDs for smaller features or quick implementations.
</command_overview>

<usage>
/generate-feature <feature_description></feature_description>

Example:
/generate-feature Add dark mode toggle to settings
</usage>

<feature_description>
$ARGUMENTS
</feature_description>

<feature_number>
Every feature is given a number. If there are no files in the ./docs/features folder, the first feature number is 0001. For every new feature generated, increment the feature-number by 1.

Pad the feature number with 0 to be 4 digits.
</feature_number>

<feature_storage_location>
./docs/features/feature-[feature-number]-[feature-name].md

Example:
./docs/features/feature-0003-dark-mode-toggle.md
</feature_storage_location>

<process>

## Step 1: Receive Feature Description
The user provides a brief description of the feature via the command parameter.

## Step 2: Understand Project Context
Quickly scan any key documentation (README.md, CLAUDE.md) to understand the project context. Keep this step brief.

## Step 3: Ask Minimal Clarifying Questions
Ask 2-3 essential questions to understand the feature better. Keep questions focused and specific.

<clarifying_questions>
## Example Clarifying Questions (choose 2-3 most relevant)

- **Core functionality:** "What are the 2-3 key things this feature should do?"
- **User benefit:** "What's the main benefit for users?"
- **Scope:** "Any specific limitations or things to avoid?"
- **UI/UX:** "Any specific UI requirements or existing patterns to follow?"
- **Dependencies:** "Does this depend on or affect other features?"
</clarifying_questions>

## Step 4: Branch Strategy
Ask the user: "Would you like to implement this feature on the current branch or create a new feature branch?"

## Step 5: Generate Feature Document
Based on the user's input, create a concise feature document using the structure below.

## Step 6: Create Markdown File
Create the feature document as a markdown file and save it to <feature_storage_location>.

## Step 7: Generate Tasks
Automatically generate a task list based on the feature requirements. Keep tasks actionable and specific.

## Step 8: Commit Feature Document (if new branch)
If creating a new branch, offer to commit the feature document to track it properly.

</process>

<feature_document_structure>

## Feature Document Structure

```markdown
# Feature: [Feature Name]

**Feature ID:** feature-[XXXX]  
**Created:** [Date]  
**Branch:** [branch-name]  

## Overview
[1-2 paragraph description of what this feature does and why it's needed]

## Goals
- [Primary goal]
- [Secondary goal]
- [Additional goals if needed]

## Key Requirements
- [Requirement 1]
- [Requirement 2]
- [Requirement 3]

## Implementation Tasks

### 1.0 Setup
- [ ] Create feature branch `feature/[feature-name]` (if needed)
- [ ] Set up necessary files and folders

### 2.0 Core Implementation
- [ ] [Main implementation task 1]
- [ ] [Main implementation task 2]
- [ ] [Main implementation task 3]
- [ ] [Additional tasks as needed]

### 3.0 UI/UX (if applicable)
- [ ] [UI task 1]
- [ ] [UI task 2]

### 4.0 Testing
- [ ] Write unit tests for [component]
- [ ] Test edge cases
- [ ] Manual testing checklist

### 5.0 Documentation
- [ ] Update relevant documentation
- [ ] Add code comments where needed
- [ ] Update README if necessary

## Notes
[Any additional notes, considerations, or dependencies]
```

</feature_document_structure>

<implementation_notes>

## Implementation Notes for Claude

1. Parse the feature description from the command parameter
2. Ask 2-3 focused clarifying questions
3. Ask about branch strategy (current vs new)
4. Generate the feature document
5. Create the markdown file in ./docs/features/
6. If new branch requested:
   - Include branch creation as first task
   - Offer to commit the feature document
7. Keep the entire process quick and focused
8. During implementation, update task checkboxes in the markdown

The goal is rapid feature documentation that's actionable, not comprehensive PRD-level detail.

</implementation_notes>

<example_workflow>

## Example Workflow

User: `/generate-feature Add export to PDF functionality`

Claude:
1. Acknowledges the feature request
2. Asks 2-3 questions: "What content should be exportable to PDF?", "Any specific formatting requirements?", "Should this be available to all users?"
3. Asks: "Would you like to implement this on the current branch or create a new feature branch?"
4. Generates concise feature document
5. Creates markdown file in ./docs/features/
6. Shows the created document path
7. If new branch chosen, offers to create branch and commit the document

</example_workflow>

<task_guidelines>

## Task Generation Guidelines

- Keep tasks concrete and actionable
- Group related tasks under clear headings
- Include setup, implementation, testing, and documentation phases
- Aim for 10-20 tasks total (not 50+)
- Focus on what needs to be done, not how

</task_guidelines>