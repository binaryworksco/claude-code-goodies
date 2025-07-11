# Setup standard workflow for the project

<command_overview>
This document is to setup a common workflow that should be followed by coding agents. You are to understand the instructions set out in the document and update the project CLAUDE.md file so these instructions are loaded into context every session.
</command_overview>

<documents>
Documents are to be created in markdown format and stored in the /docs folder as described in the <structure> section. Note that not all projects will contain the same set of documents, for example, not all projects may have UX/UI guides etc.
</documents>

<structure>
/docs                           # Root folder where all documents are to be stored.
├── README.md                   # High-level overview of the project: what it does, who it's for, etc.
├── prd/                        # Folder for all Product Requirement Documents (PRDs).
├── style/                      # Contains design and user experience guides.
│   ├── ux-guide.md             # Guide on managing the user experience of the application.
│   └── ui-guide.md             # Guide on designing the user interface of the application.
├── tech/                       # Technical documentation and architecture details.
│   └── architecture.md         # Project architecture, frameworks, patterns, infrastructure, etc.
│   └── coding-standards.md     # Coding standards and best practices you need to follow.
├── workflow.md                 # Detailed description of the workflow to follow.
└── bug-tracking.md             # Guide on managing and tracking bugs during development and testing.
</structure>

<workflow>
When you are given a task, always do the following:
1. Read the /docs/README.md file to understand the context of the project.
2. Understand the type of task you are being given, is it a UI design task, a coding task, a technical design/planning task or something else.
3. Once you have identified the type of task, read the documents from the /docs folder that specifically relate to the task. 
4. Based on your understanding from the documents and the task being given, ask any clarifying questions.
5. Before proceeding to do any implementation work, respond back to the user explaining your understanding of the task to make sure you and the user are aligned.
</workflow>

<response_style>
- Be professional and technically accurate
- Use clear, concise language
- Provide justifications for technology/technical design consideraction choices
- Be realistic about timelines and complexity
- Focus on actionable outcomes
- Ensure consistency across all documentation files
- Create logical connections between implementation, structure, and design
</response_style>

<actions>
1. Create the /docs folder structure as set out in <structure> section.
2. Update the project CLAUDE.md to include the above instructions, explaining what you need to do. Don't change the structure, workflow or response_style instructions.
</actions>