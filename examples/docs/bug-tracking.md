# Bug Tracking

This document outlines a simple method of monitoring and tracking bugs within the project.

1. Bugs are to be tracked in a markdown file which is to be stored in the folder stated in <bug_file_location> section.
2. Each bug will be stored in its own markdown file. The structure of the markdown file is shown below in the <bug_file_structure> section.
3. The file name for the bug file name will follow the <bug_filename> section.

<bug_file_location>
Root folder: /bugs
Feature folder: /bugs/[feature]
Priority folder: /bugs/[feature]/[priority (high/medium/low)]
</bug_file_location>

<bug_filename>
bug-[bug-number]-[brief-description].md

The bug number should be a running number based on the last bug created number + 1
</bug_filename>

<bug_file_structure>
```markdown
# Bug Title

**Feature Affected:** [State Feature]

**Priority:** [State Priority]

**Description**
[Create a detailed description of the issue]

## Test

**Replicate Steps**
[Explain how to replicate the issue. Include things like specific input data that needs to be entered, what the output is and what was expected]

## Fix
[Explain what the recommended fix is]

```
</bug_file_structure>