# Design System User Guide

## Overview

This guide explains how to use the Claude Code Design System commands to create consistent, professional UI designs and implementations. The design system consists of two main commands that work together to help you build beautiful, accessible web applications.

## Quick Start

1. **Generate a Style Guide**: Start by analyzing your design screenshots
2. **Create Component Showcase**: Build an HTML reference implementation
3. **Use the Components**: Copy components into your application

## Available Commands

### 1. `/design/generate-design-guide` - Create a UI Style Guide

This command analyzes screenshots of your UI design and generates a comprehensive style guide.

**Usage:**
```
/design/generate-design-guide [path-to-screenshot(s)]
```

**What it does:**
- Analyzes your design screenshots to extract actual design elements
- Creates a new design project folder: `/designs/design-[date]-[description]/`
- Generates `style-guide.md` with complete design specifications
- Creates a `README.md` with project metadata
- Provides specifications for colors, typography, spacing, components, and more
- Includes Tailwind CSS implementation notes

**Example:**
```
/design/generate-design-guide ./screenshots/app-design.png
```

This might create: `/designs/design-20240115-modern-dashboard/`

### 2. `/design/generate-html-template` - Build Component Showcase

This command takes a style guide and generates a complete HTML showcase page with all standard web components.

**Usage:**
```
/design/generate-html-template [path-to-style-guide-or-folder]
```

**What it does:**
- Reads your style guide and extracts all design tokens
- Creates multiple files in the same design project folder:
  - `component-showcase.html` - Complete component library
  - `index.html` - Landing page for the design project
  - `components/` - Optional individual component files
- Includes all standard UI components styled according to your guide
- Provides interactive examples with dark mode support

**Example:**
```
# Option 1: Provide the design folder
/design/generate-html-template /designs/design-20240115-modern-dashboard/

# Option 2: Provide the style guide directly
/design/generate-html-template /designs/design-20240115-modern-dashboard/style-guide.md
```

## Design Project Organization

Each design project is stored in its own folder under `/designs/` with a unique timestamp and descriptor:

```
/designs/
├── design-20240115-modern-dashboard/
│   ├── README.md                 # Project description and metadata
│   ├── style-guide.md           # Complete design specifications
│   ├── index.html               # Landing page for the design
│   ├── component-showcase.html  # Interactive component library
│   └── components/              # Optional individual components
├── design-20240118-minimal-blog/
│   ├── README.md
│   ├── style-guide.md
│   ├── index.html
│   └── component-showcase.html
└── design-20240122-corporate-site/
    └── ...
```

This organization allows you to:
- Maintain multiple design projects simultaneously
- Keep all related files together
- Easily reference past designs
- Share complete design packages with team members

## Workflow Guide

### Step 1: Prepare Your Design Screenshots

Before using the design system commands, ensure you have:
- High-quality screenshots of your UI design
- Multiple screens showing different components and states (if available)
- Examples of interactive states (hover, active, disabled) if possible

### Step 2: Generate the Style Guide

Run the style guide generator:
```
/design/generate-design-guide ./design-screenshots/
```

The command will:
1. Analyze your screenshots systematically
2. Extract actual colors, fonts, and spacing
3. Identify component patterns
4. Create a new design folder (e.g., `/designs/design-20240115-modern-dashboard/`)
5. Generate a comprehensive style guide at `style-guide.md`
6. Create a `README.md` with project information

**Review the generated guide** in your new design folder and make any necessary adjustments.

### Step 3: Create the Component Showcase

Once you're happy with your style guide, generate the HTML showcase:
```
/design/generate-html-template /designs/design-20240115-modern-dashboard/
```

This creates multiple files in your design folder:
- `index.html` - Landing page for your design project
- `component-showcase.html` - All standard web components
- Interactive examples with dark mode toggle
- Responsive design examples
- Copy-ready code snippets

### Step 4: Implement in Your Application

1. **Open the showcase**: View `component-showcase.html` in your browser
2. **Test components**: Interact with components, toggle dark mode, test responsiveness
3. **Copy components**: Use the HTML/CSS from the showcase in your application
4. **Maintain consistency**: Refer back to the style guide for design decisions

## Components Included

The design system covers all standard web application components:

### Navigation & Layout
- Navigation bars (expanded/collapsed)
- Sidebars (fixed/collapsible)
- Breadcrumbs
- Tabs
- Pagination
- Footer layouts

### Content & Typography
- Headings (H1-H6)
- Body text variations
- Lists (ordered/unordered)
- Blockquotes
- Code blocks

### Forms & Inputs
- Text inputs (with validation states)
- Textareas
- Select dropdowns
- Radio buttons
- Checkboxes
- Toggle switches
- File uploads
- Search inputs
- Date/time pickers
- Sliders/range inputs

### Buttons & Actions
- Primary/secondary/ghost buttons
- Button sizes and states
- Button groups
- Icon buttons
- Floating action buttons

### Feedback & Messaging
- Alerts (info/success/warning/error)
- Toast notifications
- Tooltips
- Progress bars
- Loading spinners
- Skeleton screens

### Data Display
- Tables (with sorting/filtering)
- Cards (basic/elevated/interactive)
- Lists
- Badges and pills
- Avatars
- Stats cards
- Timelines

### Overlays & Modals
- Modal dialogs
- Dropdown menus
- Context menus
- Popovers

### States
- Empty states
- Error states (404/500)
- Loading states
- Success states

### Advanced Components
- Accordions/collapsibles
- Steppers
- Image galleries
- Rating components
- Tags input
- Autocomplete

## Best Practices

### 1. Start with Real Designs
- Use actual screenshots from your design tool
- Include multiple states and variations
- Show real content, not just lorem ipsum

### 2. Review Generated Output
- Check that extracted colors match your design
- Verify typography scales are accurate
- Ensure spacing feels right
- Test component interactions

### 3. Customize as Needed
- Edit the style guide markdown if adjustments are needed
- Add custom components to the showcase
- Extend with your specific brand requirements

### 4. Maintain Consistency
- Use the generated style guide as your source of truth
- Update it when design changes occur
- Share with your team for alignment

### 5. Consider Accessibility
- The system includes WCAG AA color contrast standards
- Components include ARIA labels
- Keyboard navigation is supported
- Test with screen readers

## Customization Options

### Tailwind CSS Configuration
Both commands use Tailwind CSS. You can customize by:
- Modifying the Tailwind config in the generated HTML
- Adding custom utility classes
- Extending the color palette
- Creating custom components

### Dark Mode
The system includes automatic dark mode support:
- Toggle between light/dark themes
- Colors adjust automatically
- Maintains readability in both modes
- Respects system preferences

### Responsive Design
All components are responsive by default:
- Mobile-first approach
- Tablet and desktop optimizations
- Flexible grid system
- Touch-friendly interactions

## Troubleshooting

### Common Issues

**1. Colors don't match my design**
- Ensure screenshots are high quality
- Check color accuracy in your image files
- Manually adjust hex values in the style guide

**2. Components look different than expected**
- Review the extracted design tokens
- Check if all states were captured in screenshots
- Adjust component CSS as needed

**3. Missing components**
- Add custom components to the showcase HTML
- Extend the style guide with additional specifications
- Create component variations as needed

### Getting Help

1. **Review the style guide**: Check if specifications are correct
2. **Inspect the HTML**: Use browser DevTools to debug
3. **Check Tailwind docs**: Reference Tailwind CSS documentation
4. **Iterate**: Regenerate with better screenshots if needed

## Advanced Usage

### Multi-Language Support
The style guide includes considerations for:
- RTL languages
- Font stack variations
- Text expansion allowances
- Cultural color considerations

### Performance Optimization
- Use lazy loading for images
- Implement code splitting for large component libraries
- Optimize animations for performance
- Consider reduced motion preferences

### Integration with Frameworks
While the showcase uses vanilla HTML/JS, you can:
- Port components to React/Vue/Angular
- Create framework-specific component libraries
- Maintain design token consistency
- Use CSS-in-JS solutions

## Conclusion

The Claude Code Design System commands provide a powerful workflow for translating designs into code. By following this guide, you can:
- Quickly extract design specifications from screenshots
- Generate a comprehensive component library
- Maintain consistency across your application
- Speed up development with ready-to-use components

Remember to treat the generated files as a starting point and customize them to perfectly match your project's needs.