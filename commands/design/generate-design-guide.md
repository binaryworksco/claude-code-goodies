# Generate UX/UI Style Guide

<command_overview>
You are an expert web application UX and UI designer with many years experience. Your job is to review the screenshot(s) provided and generate a style guide based on the design you see. The rest of this document outlines exactly how you will generate the required output. When studying the design, think hard about what you see and extract the actual design elements rather than using generic values.
</command_overview>

<input>
Your reference image(s) are $ARGUMENTS.

**Image Interpretation Context**: The provided screenshot(s) may represent either a complete UI design system or partial screen samples. Analyze what is available and note any areas where design patterns need to be inferred or extended based on common UI conventions. If the screenshots show only partial interfaces, extrapolate reasonable design decisions for missing elements while clearly noting these as recommendations.
</input>

<output>
You will produce a markdown called ui-guide.md in the /docs/style folder of the project. The markdown will follow the template shown in <ui_guide_template/> section, but with values extracted from your analysis rather than the example values shown.

**Important**: When implementing components from this style guide, use Tailwind CSS utility classes for styling.
</output>

<analysis_instructions>
Before generating the style guide, analyze the screenshots systematically:

## Color Analysis
- **Extract Primary Colors**: Identify the most prominent brand color(s) used for CTAs, headers, or key UI elements
- **Find Secondary Colors**: Look for supporting colors used for accents or secondary actions
- **Identify Neutral Palette**: Extract the grays/neutrals used for text, borders, and backgrounds
- **Detect Semantic Colors**: Find success (green), error (red), warning (yellow), and info (blue) colors if present
- **Note Color Relationships**: Observe how colors are used together and their hierarchy

## Typography Analysis
- **Font Family Detection**: Look at the character shapes to identify the font family (sans-serif, serif, specific fonts)
- **Type Scale**: Measure or estimate the sizes of headings, body text, and captions
- **Font Weights**: Identify which weights are used (light, regular, medium, bold)
- **Line Heights**: Observe the spacing between lines of text
- **Letter Spacing**: Note any special tracking on headlines or UI elements

## Spacing Pattern Detection
- **Base Unit**: Look for a consistent spacing unit (often 4px or 8px)
- **Padding Patterns**: Measure internal spacing within components
- **Margin Patterns**: Observe spacing between components
- **Grid System**: Identify column counts and gutter widths if visible

## Component Analysis
- **Button Styles**: Extract exact colors, padding, border radius, and typography
- **Form Elements**: Note input field styles, heights, and states if shown
- **Card Patterns**: Identify shadow depths, border styles, and padding
- **Navigation**: Analyze menu styles, active states, and hover effects if visible

## Visual Hierarchy Recognition
- **Elevation**: Note shadow usage and depths
- **Contrast**: Observe how contrast creates hierarchy
- **Size Relationships**: Identify proportional relationships between elements
- **Visual Weight**: Note how boldness, color, and size create emphasis
</analysis_instructions>

<ui_guide_template>
```
# UI Style Guide

## 1. Visual Foundation

### 1.1 Design System Overview
A comprehensive visual language that ensures consistency, scalability, and brand recognition across all digital touchpoints.

### 1.2 Visual Design Principles
- **Clarity**: Clean, uncluttered interfaces
- **Hierarchy**: Clear visual importance
- **Balance**: Harmonious composition
- **Rhythm**: Consistent spacing and alignment
- **Unity**: Cohesive visual system

## 2. Color System

### 2.1 Color Palette

**Brand Colors**
- Primary: #0066CC (Royal Blue)
  - RGB: 0, 102, 204
  - HSL: 210°, 100%, 40%
- Secondary: #00A86B (Emerald)
  - RGB: 0, 168, 107
  - HSL: 158°, 100%, 33%
- Accent: #FF6B35 (Sunset Orange)
  - RGB: 255, 107, 53
  - HSL: 16°, 100%, 60%

**Neutral Palette**
- Gray 900: #111111
- Gray 800: #333333
- Gray 700: #555555
- Gray 600: #666666
- Gray 500: #888888
- Gray 400: #AAAAAA
- Gray 300: #CCCCCC
- Gray 200: #E5E5E5
- Gray 100: #F5F5F5
- White: #FFFFFF

**Semantic Colors**
- Success: #28A745
- Success Light: #D4EDDA
- Warning: #FFC107
- Warning Light: #FFF3CD
- Error: #DC3545
- Error Light: #F8D7DA
- Info: #17A2B8
- Info Light: #D1ECF1

### 2.2 Color Usage

**Backgrounds**
- Primary Background: White (#FFFFFF)
- Secondary Background: Gray 100 (#F5F5F5)
- Dark Mode Primary: Gray 900 (#111111)
- Dark Mode Secondary: Gray 800 (#333333)

**Text Colors**
- Primary Text: Gray 900 (#111111)
- Secondary Text: Gray 600 (#666666)
- Disabled Text: Gray 400 (#AAAAAA)
- Link Color: Primary Blue (#0066CC)
- Link Hover: Darken 10%

### 2.3 Color Accessibility
- Maintain WCAG AA standards
- Primary on White: 5.85:1
- Body text on White: 17.45:1
- Use color blind safe combinations

## 3. Typography

### 3.1 Type Scale

**Display Sizes**
- Display Large: 56px/64px (3.5rem/4rem)
- Display Medium: 48px/56px (3rem/3.5rem)
- Display Small: 40px/48px (2.5rem/3rem)

**Heading Sizes**
- H1: 32px/40px (2rem/2.5rem)
- H2: 28px/36px (1.75rem/2.25rem)
- H3: 24px/32px (1.5rem/2rem)
- H4: 20px/28px (1.25rem/1.75rem)
- H5: 18px/24px (1.125rem/1.5rem)
- H6: 16px/24px (1rem/1.5rem)

**Body Text**
- Large: 18px/28px (1.125rem/1.75rem)
- Regular: 16px/24px (1rem/1.5rem)
- Small: 14px/20px (0.875rem/1.25rem)
- Caption: 12px/16px (0.75rem/1rem)

### 3.2 Font Stack

**Primary Font**
```css
font-family: -apple-system, BlinkMacSystemFont, 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
```

**Monospace Font**
```css
font-family: 'SF Mono', Monaco, 'Cascadia Code', 'Roboto Mono', Consolas, 'Courier New', monospace;
```

### 3.3 Font Weights
- Light: 300
- Regular: 400
- Medium: 500
- Semibold: 600
- Bold: 700

### 3.4 Typography Guidelines
- Line height: 1.5 for body text
- Letter spacing: -0.02em for headlines
- Max line length: 65-75 characters
- Paragraph spacing: 16px

## 4. Grid & Layout

### 4.1 Grid System

**Container Widths**
- Mobile: 100% - 32px padding
- Tablet: 768px
- Desktop: 1024px
- Wide: 1280px
- Max: 1440px

**Column Grid**
- Desktop: 12 columns, 24px gutter
- Tablet: 8 columns, 16px gutter  
- Mobile: 4 columns, 16px gutter

### 4.2 Spacing System

**Base Unit**: 8px

**Spacing Scale**
- 0: 0px
- 1: 4px (0.5 unit)
- 2: 8px (1 unit)
- 3: 12px (1.5 units)
- 4: 16px (2 units)
- 5: 24px (3 units)
- 6: 32px (4 units)
- 7: 40px (5 units)
- 8: 48px (6 units)
- 9: 64px (8 units)
- 10: 80px (10 units)

### 4.3 Layout Patterns
- Card layouts: 16px or 24px padding
- Section spacing: 48px to 80px
- Component spacing: 16px to 32px
- Inline spacing: 8px to 16px

## 5. Components

### 5.1 Buttons

**Primary Button**
```css
background: #0066CC;
color: #FFFFFF;
padding: 12px 24px;
border-radius: 6px;
font-size: 16px;
font-weight: 600;
min-height: 44px;
border: none;
```

**Secondary Button**
```css
background: transparent;
color: #0066CC;
padding: 12px 24px;
border: 2px solid #0066CC;
border-radius: 6px;
```

**Ghost Button**
```css
background: transparent;
color: #666666;
padding: 12px 24px;
border: 2px solid #CCCCCC;
```

**Button States**
- Hover: Darken 10%
- Active: Darken 20%
- Focus: 3px offset outline
- Disabled: 50% opacity
- Loading: Spinner icon

### 5.2 Form Elements

**Text Input**
```css
height: 44px;
padding: 12px 16px;
border: 1px solid #CCCCCC;
border-radius: 4px;
font-size: 16px;
background: #FFFFFF;
```

**Input States**
- Focus: 2px solid #0066CC
- Error: 2px solid #DC3545
- Success: 2px solid #28A745
- Disabled: background #F5F5F5

**Labels**
```css
font-size: 14px;
font-weight: 500;
color: #333333;
margin-bottom: 8px;
```

### 5.3 Cards

**Basic Card**
```css
background: #FFFFFF;
border: 1px solid #E5E5E5;
border-radius: 8px;
padding: 24px;
box-shadow: 0 2px 4px rgba(0,0,0,0.05);
```

**Elevated Card**
```css
box-shadow: 0 4px 8px rgba(0,0,0,0.1);
```

**Interactive Card**
```css
transition: all 0.2s ease;
cursor: pointer;
&:hover {
  box-shadow: 0 8px 16px rgba(0,0,0,0.15);
  transform: translateY(-2px);
}
```

## 6. Icons

### 6.1 Icon Specifications
- Style: Outlined, 2px stroke weight
- Grid: 24x24px base
- Sizes: 16px, 20px, 24px, 32px, 48px
- Corner radius: 2px for rounded elements

### 6.2 Icon Color Usage
- Default: Inherit from parent
- Interactive: Primary blue
- Disabled: Gray 400
- Semantic: Match semantic colors

### 6.3 Icon Guidelines
- Maintain 2px minimum spacing
- Optical alignment over mathematical
- Consistent stroke terminals
- 45° angles when possible

## 7. Shadows & Elevation

### 7.1 Shadow System

**Elevation Levels**
```css
/* Level 0 - No shadow (flat) */
box-shadow: none;

/* Level 1 - Subtle */
box-shadow: 0 1px 2px rgba(0,0,0,0.05);

/* Level 2 - Small */
box-shadow: 0 2px 4px rgba(0,0,0,0.1);

/* Level 3 - Medium */
box-shadow: 0 4px 8px rgba(0,0,0,0.15);

/* Level 4 - Large */
box-shadow: 0 8px 16px rgba(0,0,0,0.2);

/* Level 5 - Extra Large */
box-shadow: 0 16px 32px rgba(0,0,0,0.25);
```

### 7.2 Usage Guidelines
- Cards: Level 2
- Dropdowns: Level 3
- Modals: Level 4
- Tooltips: Level 2
- Sticky elements: Level 3

## 8. Border Styles

### 8.1 Border Radius
- Small: 4px (inputs, tags)
- Medium: 6px (buttons)
- Large: 8px (cards, containers)
- Extra Large: 12px (modals)
- Round: 50% (avatars)
- Pill: 9999px (badges)

### 8.2 Border Styles
- Default: 1px solid #E5E5E5
- Focus: 2px solid #0066CC
- Error: 2px solid #DC3545
- Subtle: 1px solid #F5F5F5

## 9. Animation

### 9.1 Duration Scale
- Instant: 0ms
- Micro: 100ms
- Short: 200ms
- Medium: 300ms
- Long: 400ms
- Extra Long: 600ms

### 9.2 Easing Functions
```css
/* Default - Ease out */
transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);

/* Ease in */
transition-timing-function: cubic-bezier(0.4, 0, 1, 1);

/* Ease in-out */
transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);

/* Spring */
transition-timing-function: cubic-bezier(0.68, -0.55, 0.265, 1.55);
```

### 9.3 Common Animations
- Fade: opacity 200ms
- Slide: transform 300ms
- Scale: transform 200ms
- Color: background-color 200ms

## 10. Responsive Breakpoints

### 10.1 Breakpoint Values
```css
/* Mobile First */
$mobile: 320px;
$tablet: 768px;
$desktop: 1024px;
$wide: 1280px;
$ultra: 1440px;
```

### 10.2 Media Queries
```css
/* Tablet and up */
@media (min-width: 768px) { }

/* Desktop and up */
@media (min-width: 1024px) { }

/* Wide screens */
@media (min-width: 1280px) { }
```

## 11. Component States

### 11.1 Interactive States
- **Default**: Base appearance
- **Hover**: User feedback
- **Focus**: Keyboard navigation
- **Active**: Being clicked
- **Disabled**: Non-interactive
- **Loading**: Processing

### 11.2 Validation States
- **Neutral**: Default state
- **Valid**: Green indicators
- **Invalid**: Red indicators
- **Warning**: Yellow indicators

## 12. Dark Mode

### 12.1 Dark Mode Colors
- Background: #111111
- Surface: #1A1A1A
- Border: #333333
- Text Primary: #FFFFFF
- Text Secondary: #CCCCCC

### 12.2 Dark Mode Adjustments
- Reduce contrast for comfort
- Adjust shadows (lighter, less opacity)
- Invert elevation (darker = higher)
- Mute brand colors by 10%

## 13. Multi-language Support

### 13.1 Typography Adjustments
- Font stacks for different scripts
  - Latin: Inter, -apple-system
  - Chinese: PingFang SC, Microsoft YaHei
  - Japanese: Hiragino Sans, Yu Gothic
  - Arabic: Segoe UI, Tahoma
  - Hindi: Noto Sans Devanagari
- Line height adjustments per language
- Font size modifications for readability

### 13.2 Layout Adaptations
- RTL (Right-to-Left) mirroring
- Flexible container widths for text expansion
- Dynamic spacing for character density
- Bidirectional (BiDi) text handling

### 13.3 Component Modifications
- Button padding for text expansion
- Form field width flexibility
- Navigation menu text wrapping
- Truncation rules per language

### 13.4 Visual Adjustments
- Culturally appropriate imagery
- Icon directionality (arrows, etc.)
- Color cultural meanings
- Reading patterns (F-pattern vs RTL)

## 14. Assets & Resources

### 14.1 Image Guidelines
- Formats: WebP, JPEG, PNG, SVG
- Responsive images with srcset
- Lazy loading for performance
- Alt text for accessibility

### 14.2 Design Tokens
Export as:
- CSS custom properties
- SCSS variables
- JavaScript constants
- JSON tokens
- Tailwind config extensions

## 15. Navigation Patterns

### 15.1 Primary Navigation
- Style: [Describe based on screenshot]
- Placement: [Top/Side/Bottom]
- Behavior: [Sticky/Static/Responsive]
- Active state: [Color/Underline/Background]

### 15.2 Secondary Navigation
- Breadcrumbs style
- Tab navigation patterns
- Pagination components
- Mobile menu behavior

### 15.3 Navigation States
- Default
- Hover
- Active/Current
- Disabled
- Loading

## 16. Data Visualization

### 16.1 Chart Colors
- Primary data series
- Secondary data series
- Categorical palettes
- Sequential palettes
- Diverging palettes

### 16.2 Chart Typography
- Axis labels
- Data labels
- Legends
- Tooltips

### 16.3 Chart Components
- Grid lines
- Axis styles
- Legend placement
- Tooltip design

## 17. Tables & Data Display

### 17.1 Table Structure
```css
/* Tailwind CSS example */
@apply border-collapse w-full;
```

### 17.2 Table Elements
- Header row styling
- Data row styling
- Alternating row colors
- Hover states
- Selected states

### 17.3 Table Features
- Sorting indicators
- Filter UI
- Pagination
- Bulk actions
- Responsive behavior

## 18. Modals & Overlays

### 18.1 Modal Structure
- Overlay color and opacity
- Modal container styles
- Maximum widths
- Border radius
- Shadow depth

### 18.2 Modal Components
- Header design
- Body padding
- Footer alignment
- Close button placement

### 18.3 Modal Variations
- Confirmation dialogs
- Form modals
- Media modals
- Full-screen modals

## 19. Notifications & Toasts

### 19.1 Toast Notifications
- Position: [top-right/top-center/bottom-right]
- Animation: [slide/fade]
- Duration: [auto-dismiss time]
- Stacking behavior

### 19.2 Notification Types
- Success notifications
- Error notifications
- Warning notifications
- Info notifications
- Custom notifications

### 19.3 Notification Components
- Icon placement
- Message styling
- Action buttons
- Dismiss controls
- Progress indicators

## 20. Loading & Progress States

### 20.1 Loading Indicators
- Spinner design
- Skeleton screens
- Progress bars
- Loading overlays
- Shimmer effects

### 20.2 Progress Feedback
- Linear progress
- Circular progress
- Step indicators
- Percentage displays

### 20.3 Loading Patterns
- Inline loading
- Full-page loading
- Lazy loading
- Progressive loading

## 21. Empty & Error States

### 21.1 Empty States
- Illustration style
- Message hierarchy
- Action prompts
- Help text

### 21.2 Error States
- 404 pages
- 500 errors
- Form validation errors
- Network errors
- Permission errors

### 21.3 State Components
- Icon/illustration usage
- Typography hierarchy
- Color usage
- Action buttons
- Help links

## 22. Motion Design Philosophy

### 22.1 Animation Principles
- **Purpose-Driven**: Every animation should enhance usability, not distract
- **Performance-First**: Animations must not hinder application performance
- **Accessibility**: Respect prefers-reduced-motion settings
- **Consistency**: Similar actions should have similar animations
- **Natural**: Movements should feel organic and follow real-world physics

### 22.2 Animation Guidelines
- **Micro-interactions**: Small, functional animations (100-200ms)
- **Page Transitions**: Smooth navigation between views (200-300ms)
- **Data Loading**: Progressive reveal for content (300-400ms)
- **Feedback**: Immediate response to user actions (<100ms)
- **Orchestration**: Stagger related animations for visual hierarchy

### 22.3 Implementation Notes
```css
/* Tailwind CSS transition utilities */
@apply transition-all duration-200 ease-out;
@apply hover:scale-105 active:scale-95;
```

## 23. Tone & Brand Personality

### 23.1 Brand Voice Definition
**Note to implementer**: Before using this style guide to generate UI components, please gather the following brand personality information from the stakeholders:

- **Brand Personality Traits**: (e.g., Professional, Friendly, Innovative, Trustworthy)
- **Voice Characteristics**: (e.g., Formal/Casual, Technical/Simple, Serious/Playful)
- **Emotional Tone**: How should users feel when using the interface?
- **Key Differentiators**: What makes this brand unique in its space?

### 23.2 Visual Personality
Based on the analyzed screenshots, the visual design suggests:
- [Describe the personality implied by the visual design]
- [Note any specific design choices that convey brand values]
- [Identify how color, typography, and spacing support the brand]

### 23.3 Content Guidelines
- **Headings**: [Tone and style for headers]
- **Body Copy**: [Tone for general content]
- **CTAs**: [Action-oriented language style]
- **Error Messages**: [Helpful vs. technical tone]
- **Success Messages**: [Celebratory vs. matter-of-fact]

### 23.4 Implementation Considerations
When generating UI components:
1. Align all copy with the defined brand voice
2. Ensure visual design supports the brand personality
3. Maintain consistency across all touchpoints
4. Consider cultural sensitivity for global audiences
```
</ui_guide_template>

<verification>
Once the UI guide has been created, review your work and grade it from a scale of 1 (worst) to 10 (best). Grade each major section of the UI guide you have produced against the original input image. 

**Critical Verification Points**:
1. Did you extract actual colors from the screenshots rather than using the template examples?
2. Did you identify the real typography choices visible in the design?
3. Did you measure or estimate actual spacing values from the screenshots?
4. Did you describe components as they actually appear, not from the template?
5. Did you note where you had to make assumptions due to limited screenshot coverage?

If any of the sections score less than 8, review the input images and redo the UI guide for that section. Remember: This guide should reflect the actual design in the screenshots, not generic values.

Before finalizing, also ensure:
- All Tailwind CSS implementation notes are included where relevant
- The brand personality section prompts for stakeholder input
- Motion design philosophy aligns with the observed UI behavior
- Any design patterns you couldn't observe are clearly marked as recommendations
</verification>
