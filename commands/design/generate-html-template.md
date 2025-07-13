# Generate HTML Component Template

<command_overview>
You are an expert frontend developer specializing in creating comprehensive UI component libraries. Your task is to generate a complete HTML showcase page that demonstrates all standard web application components based on a provided design style guide. This page will serve as a living reference for developers implementing the design system.
</command_overview>

<input>
The style guide to follow is: $ARGUMENTS

**Important**: You must follow the provided style guide meticulously. Extract all colors, typography, spacing, and component specifications from the guide and implement them exactly as specified.
</input>

<style_guide_analysis>
Before generating the HTML, carefully analyze the provided style guide and extract:
1. Color values (primary, secondary, neutrals, semantic colors)
2. Typography settings (font families, sizes, weights, line heights)
3. Spacing system (base unit and scale)
4. Component specifications (buttons, forms, cards, etc.)
5. Animation/transition settings
6. Dark mode color mappings
7. Tailwind CSS configuration requirements
8. Brand personality and tone guidelines
</style_guide_analysis>

<output>
Generate a single HTML file named `component-showcase.html` that includes:
1. All CSS (using Tailwind CSS utilities as specified in the style guide)
2. All JavaScript for interactive functionality
3. A comprehensive showcase of every component
4. Dark mode toggle functionality
5. Responsive design demonstrations
6. Code examples for each component
</output>

<html_template>
```html
<!DOCTYPE html>
<html lang="en" class="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Component Showcase - [Brand Name] Design System</title>
    
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    
    <!-- Configure Tailwind with extracted design tokens -->
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    colors: {
                        // Extract from style guide
                        'primary': '[PRIMARY_COLOR]',
                        'secondary': '[SECONDARY_COLOR]',
                        // ... add all colors from guide
                    },
                    fontFamily: {
                        // Extract from style guide
                        'sans': '[FONT_STACK]',
                    },
                    spacing: {
                        // Add custom spacing if needed
                    },
                    // Add other extensions from style guide
                }
            }
        }
    </script>
    
    <!-- Component Styles -->
    <style>
        /* Custom CSS for components not easily achieved with Tailwind */
        /* Extract any custom CSS from the style guide */
    </style>
</head>
<body class="bg-white dark:bg-gray-900 text-gray-900 dark:text-white transition-colors duration-200">
    
    <!-- Navigation -->
    <nav class="sticky top-0 z-50 bg-white dark:bg-gray-900 border-b border-gray-200 dark:border-gray-800">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between h-16">
                <div class="flex items-center">
                    <h1 class="text-xl font-semibold">Component Showcase</h1>
                </div>
                <div class="flex items-center space-x-4">
                    <!-- Dark Mode Toggle -->
                    <button id="darkModeToggle" class="p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800">
                        <svg class="w-5 h-5 hidden dark:block" fill="currentColor" viewBox="0 0 20 20">
                            <path d="M10 2a1 1 0 011 1v1a1 1 0 11-2 0V3a1 1 0 011-1zm4 8a4 4 0 11-8 0 4 4 0 018 0zm-.464 4.95l.707.707a1 1 0 001.414-1.414l-.707-.707a1 1 0 00-1.414 1.414zm2.12-10.607a1 1 0 010 1.414l-.706.707a1 1 0 11-1.414-1.414l.707-.707a1 1 0 011.414 0zM17 11a1 1 0 100-2h-1a1 1 0 100 2h1zm-7 4a1 1 0 011 1v1a1 1 0 11-2 0v-1a1 1 0 011-1zM5.05 6.464A1 1 0 106.465 5.05l-.708-.707a1 1 0 00-1.414 1.414l.707.707zm1.414 8.486l-.707.707a1 1 0 01-1.414-1.414l.707-.707a1 1 0 011.414 1.414zM4 11a1 1 0 100-2H3a1 1 0 000 2h1z"/>
                        </svg>
                        <svg class="w-5 h-5 block dark:hidden" fill="currentColor" viewBox="0 0 20 20">
                            <path d="M17.293 13.293A8 8 0 016.707 2.707a8.001 8.001 0 1010.586 10.586z"/>
                        </svg>
                    </button>
                </div>
            </div>
        </div>
    </nav>
    
    <!-- Sidebar Navigation -->
    <div class="flex">
        <aside class="w-64 h-[calc(100vh-4rem)] sticky top-16 bg-gray-50 dark:bg-gray-800 border-r border-gray-200 dark:border-gray-700 overflow-y-auto">
            <nav class="p-4 space-y-2">
                <a href="#typography" class="block px-3 py-2 rounded-md hover:bg-gray-200 dark:hover:bg-gray-700">Typography</a>
                <a href="#buttons" class="block px-3 py-2 rounded-md hover:bg-gray-200 dark:hover:bg-gray-700">Buttons</a>
                <a href="#forms" class="block px-3 py-2 rounded-md hover:bg-gray-200 dark:hover:bg-gray-700">Forms</a>
                <a href="#navigation" class="block px-3 py-2 rounded-md hover:bg-gray-200 dark:hover:bg-gray-700">Navigation</a>
                <a href="#feedback" class="block px-3 py-2 rounded-md hover:bg-gray-200 dark:hover:bg-gray-700">Feedback</a>
                <a href="#data-display" class="block px-3 py-2 rounded-md hover:bg-gray-200 dark:hover:bg-gray-700">Data Display</a>
                <a href="#overlays" class="block px-3 py-2 rounded-md hover:bg-gray-200 dark:hover:bg-gray-700">Overlays</a>
                <a href="#states" class="block px-3 py-2 rounded-md hover:bg-gray-200 dark:hover:bg-gray-700">States</a>
                <a href="#misc" class="block px-3 py-2 rounded-md hover:bg-gray-200 dark:hover:bg-gray-700">Miscellaneous</a>
            </nav>
        </aside>
        
        <!-- Main Content -->
        <main class="flex-1 p-8 max-w-6xl">
            
            <!-- Typography Section -->
            <section id="typography" class="mb-16">
                <h2 class="text-3xl font-bold mb-8">Typography</h2>
                
                <!-- Headings -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Headings</h3>
                    <div class="space-y-4">
                        <h1 class="text-5xl font-bold">Heading 1</h1>
                        <h2 class="text-4xl font-bold">Heading 2</h2>
                        <h3 class="text-3xl font-bold">Heading 3</h3>
                        <h4 class="text-2xl font-bold">Heading 4</h4>
                        <h5 class="text-xl font-bold">Heading 5</h5>
                        <h6 class="text-lg font-bold">Heading 6</h6>
                    </div>
                </div>
                
                <!-- Body Text -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Body Text</h3>
                    <p class="text-base mb-4">Regular body text. Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
                    <p class="text-sm text-gray-600 dark:text-gray-400">Small body text for secondary information.</p>
                    <p class="text-xs text-gray-500 dark:text-gray-500">Caption text for additional context.</p>
                </div>
                
                <!-- Lists -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Lists</h3>
                    <div class="grid grid-cols-2 gap-8">
                        <div>
                            <h4 class="font-medium mb-2">Unordered List</h4>
                            <ul class="list-disc list-inside space-y-1">
                                <li>List item one</li>
                                <li>List item two</li>
                                <li>List item three</li>
                            </ul>
                        </div>
                        <div>
                            <h4 class="font-medium mb-2">Ordered List</h4>
                            <ol class="list-decimal list-inside space-y-1">
                                <li>First item</li>
                                <li>Second item</li>
                                <li>Third item</li>
                            </ol>
                        </div>
                    </div>
                </div>
            </section>
            
            <!-- Buttons Section -->
            <section id="buttons" class="mb-16">
                <h2 class="text-3xl font-bold mb-8">Buttons</h2>
                
                <!-- Button Variants -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Button Variants</h3>
                    <div class="flex flex-wrap gap-4">
                        <button class="px-4 py-2 bg-primary text-white rounded-md hover:bg-primary/90 transition-colors">
                            Primary Button
                        </button>
                        <button class="px-4 py-2 bg-secondary text-white rounded-md hover:bg-secondary/90 transition-colors">
                            Secondary Button
                        </button>
                        <button class="px-4 py-2 border-2 border-primary text-primary rounded-md hover:bg-primary hover:text-white transition-colors">
                            Outline Button
                        </button>
                        <button class="px-4 py-2 text-primary hover:bg-gray-100 dark:hover:bg-gray-800 rounded-md transition-colors">
                            Ghost Button
                        </button>
                        <button class="px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700 transition-colors">
                            Danger Button
                        </button>
                        <button class="px-4 py-2 bg-gray-300 text-gray-500 rounded-md cursor-not-allowed" disabled>
                            Disabled Button
                        </button>
                    </div>
                </div>
                
                <!-- Button Sizes -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Button Sizes</h3>
                    <div class="flex items-center gap-4">
                        <button class="px-3 py-1 text-sm bg-primary text-white rounded-md">Small</button>
                        <button class="px-4 py-2 bg-primary text-white rounded-md">Medium</button>
                        <button class="px-6 py-3 text-lg bg-primary text-white rounded-md">Large</button>
                    </div>
                </div>
                
                <!-- Button Groups -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Button Groups</h3>
                    <div class="inline-flex rounded-md shadow-sm" role="group">
                        <button class="px-4 py-2 text-sm font-medium text-gray-900 bg-white border border-gray-200 rounded-l-lg hover:bg-gray-100 dark:bg-gray-700 dark:border-gray-600 dark:text-white dark:hover:bg-gray-600">
                            Left
                        </button>
                        <button class="px-4 py-2 text-sm font-medium text-gray-900 bg-white border-t border-b border-gray-200 hover:bg-gray-100 dark:bg-gray-700 dark:border-gray-600 dark:text-white dark:hover:bg-gray-600">
                            Middle
                        </button>
                        <button class="px-4 py-2 text-sm font-medium text-gray-900 bg-white border border-gray-200 rounded-r-lg hover:bg-gray-100 dark:bg-gray-700 dark:border-gray-600 dark:text-white dark:hover:bg-gray-600">
                            Right
                        </button>
                    </div>
                </div>
                
                <!-- Icon Buttons -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Icon Buttons</h3>
                    <div class="flex gap-4">
                        <button class="p-2 bg-primary text-white rounded-md hover:bg-primary/90">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"/>
                            </svg>
                        </button>
                        <button class="p-2 text-gray-600 hover:bg-gray-100 dark:text-gray-400 dark:hover:bg-gray-800 rounded-md">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m9.032 4.026a9 9 0 10-13.432 0M12 21v-6"/>
                            </svg>
                        </button>
                    </div>
                </div>
            </section>
            
            <!-- Forms Section -->
            <section id="forms" class="mb-16">
                <h2 class="text-3xl font-bold mb-8">Forms</h2>
                
                <!-- Text Inputs -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Text Inputs</h3>
                    <div class="space-y-4 max-w-md">
                        <div>
                            <label class="block text-sm font-medium mb-1">Default Input</label>
                            <input type="text" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary focus:border-primary dark:bg-gray-800 dark:border-gray-600" placeholder="Enter text...">
                        </div>
                        <div>
                            <label class="block text-sm font-medium mb-1">Input with Error</label>
                            <input type="text" class="w-full px-3 py-2 border-2 border-red-500 rounded-md focus:outline-none focus:ring-2 focus:ring-red-500 dark:bg-gray-800" placeholder="Invalid input">
                            <p class="mt-1 text-sm text-red-500">This field is required</p>
                        </div>
                        <div>
                            <label class="block text-sm font-medium mb-1">Input with Success</label>
                            <input type="text" class="w-full px-3 py-2 border-2 border-green-500 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500 dark:bg-gray-800" value="Valid input">
                            <p class="mt-1 text-sm text-green-500">Looks good!</p>
                        </div>
                        <div>
                            <label class="block text-sm font-medium mb-1">Disabled Input</label>
                            <input type="text" class="w-full px-3 py-2 border border-gray-300 rounded-md bg-gray-100 cursor-not-allowed dark:bg-gray-700 dark:border-gray-600" placeholder="Disabled" disabled>
                        </div>
                    </div>
                </div>
                
                <!-- Textarea -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Textarea</h3>
                    <div class="max-w-md">
                        <label class="block text-sm font-medium mb-1">Message</label>
                        <textarea class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary focus:border-primary dark:bg-gray-800 dark:border-gray-600" rows="4" placeholder="Enter your message..."></textarea>
                    </div>
                </div>
                
                <!-- Select/Dropdown -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Select Dropdown</h3>
                    <div class="max-w-md">
                        <label class="block text-sm font-medium mb-1">Choose an option</label>
                        <select class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary focus:border-primary dark:bg-gray-800 dark:border-gray-600">
                            <option>Select an option</option>
                            <option>Option 1</option>
                            <option>Option 2</option>
                            <option>Option 3</option>
                        </select>
                    </div>
                </div>
                
                <!-- Checkboxes -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Checkboxes</h3>
                    <div class="space-y-2">
                        <label class="flex items-center">
                            <input type="checkbox" class="w-4 h-4 text-primary border-gray-300 rounded focus:ring-primary">
                            <span class="ml-2">Default checkbox</span>
                        </label>
                        <label class="flex items-center">
                            <input type="checkbox" class="w-4 h-4 text-primary border-gray-300 rounded focus:ring-primary" checked>
                            <span class="ml-2">Checked checkbox</span>
                        </label>
                        <label class="flex items-center">
                            <input type="checkbox" class="w-4 h-4 text-gray-400 border-gray-300 rounded cursor-not-allowed" disabled>
                            <span class="ml-2 text-gray-400">Disabled checkbox</span>
                        </label>
                    </div>
                </div>
                
                <!-- Radio Buttons -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Radio Buttons</h3>
                    <div class="space-y-2">
                        <label class="flex items-center">
                            <input type="radio" name="radio-group" class="w-4 h-4 text-primary border-gray-300 focus:ring-primary">
                            <span class="ml-2">Option 1</span>
                        </label>
                        <label class="flex items-center">
                            <input type="radio" name="radio-group" class="w-4 h-4 text-primary border-gray-300 focus:ring-primary" checked>
                            <span class="ml-2">Option 2 (selected)</span>
                        </label>
                        <label class="flex items-center">
                            <input type="radio" name="radio-group" class="w-4 h-4 text-primary border-gray-300 focus:ring-primary">
                            <span class="ml-2">Option 3</span>
                        </label>
                    </div>
                </div>
                
                <!-- Toggle Switch -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Toggle Switch</h3>
                    <label class="relative inline-flex items-center cursor-pointer">
                        <input type="checkbox" class="sr-only peer">
                        <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-primary/20 dark:peer-focus:ring-primary/40 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-primary"></div>
                        <span class="ml-3">Enable notifications</span>
                    </label>
                </div>
                
                <!-- File Upload -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">File Upload</h3>
                    <div class="max-w-md">
                        <label class="block text-sm font-medium mb-2">Upload file</label>
                        <div class="flex items-center justify-center w-full">
                            <label class="flex flex-col items-center justify-center w-full h-32 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 dark:bg-gray-700 hover:bg-gray-100 dark:border-gray-600 dark:hover:bg-gray-800">
                                <div class="flex flex-col items-center justify-center pt-5 pb-6">
                                    <svg class="w-8 h-8 mb-4 text-gray-500 dark:text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"/>
                                    </svg>
                                    <p class="mb-2 text-sm text-gray-500 dark:text-gray-400">
                                        <span class="font-semibold">Click to upload</span> or drag and drop
                                    </p>
                                    <p class="text-xs text-gray-500 dark:text-gray-400">PNG, JPG, GIF up to 10MB</p>
                                </div>
                                <input type="file" class="hidden">
                            </label>
                        </div>
                    </div>
                </div>
                
                <!-- Search Input -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Search Input</h3>
                    <div class="max-w-md">
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
                                <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                                </svg>
                            </div>
                            <input type="search" class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary focus:border-primary dark:bg-gray-800 dark:border-gray-600" placeholder="Search...">
                        </div>
                    </div>
                </div>
            </section>
            
            <!-- Navigation Section -->
            <section id="navigation" class="mb-16">
                <h2 class="text-3xl font-bold mb-8">Navigation</h2>
                
                <!-- Breadcrumbs -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Breadcrumbs</h3>
                    <nav class="flex" aria-label="Breadcrumb">
                        <ol class="inline-flex items-center space-x-1 md:space-x-3">
                            <li class="inline-flex items-center">
                                <a href="#" class="text-gray-700 hover:text-primary dark:text-gray-400 dark:hover:text-white">
                                    Home
                                </a>
                            </li>
                            <li>
                                <div class="flex items-center">
                                    <svg class="w-3 h-3 text-gray-400 mx-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                                    </svg>
                                    <a href="#" class="ml-1 text-gray-700 hover:text-primary dark:text-gray-400 dark:hover:text-white">
                                        Products
                                    </a>
                                </div>
                            </li>
                            <li aria-current="page">
                                <div class="flex items-center">
                                    <svg class="w-3 h-3 text-gray-400 mx-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                                    </svg>
                                    <span class="ml-1 text-gray-500 dark:text-gray-400">
                                        Current Page
                                    </span>
                                </div>
                            </li>
                        </ol>
                    </nav>
                </div>
                
                <!-- Tabs -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Tabs</h3>
                    <div class="border-b border-gray-200 dark:border-gray-700">
                        <nav class="-mb-px flex space-x-8">
                            <a href="#" class="py-2 px-1 border-b-2 border-primary font-medium text-sm text-primary">
                                Active Tab
                            </a>
                            <a href="#" class="py-2 px-1 border-b-2 border-transparent font-medium text-sm text-gray-500 hover:text-gray-700 hover:border-gray-300 dark:text-gray-400 dark:hover:text-gray-300">
                                Tab 2
                            </a>
                            <a href="#" class="py-2 px-1 border-b-2 border-transparent font-medium text-sm text-gray-500 hover:text-gray-700 hover:border-gray-300 dark:text-gray-400 dark:hover:text-gray-300">
                                Tab 3
                            </a>
                            <a href="#" class="py-2 px-1 border-b-2 border-transparent font-medium text-sm text-gray-400 cursor-not-allowed">
                                Disabled Tab
                            </a>
                        </nav>
                    </div>
                </div>
                
                <!-- Pagination -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Pagination</h3>
                    <nav class="flex items-center justify-between">
                        <div class="flex-1 flex justify-between sm:hidden">
                            <a href="#" class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                                Previous
                            </a>
                            <a href="#" class="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                                Next
                            </a>
                        </div>
                        <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
                            <div>
                                <p class="text-sm text-gray-700 dark:text-gray-400">
                                    Showing <span class="font-medium">1</span> to <span class="font-medium">10</span> of <span class="font-medium">97</span> results
                                </p>
                            </div>
                            <div>
                                <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination">
                                    <a href="#" class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 dark:bg-gray-800 dark:border-gray-600 dark:hover:bg-gray-700">
                                        <span class="sr-only">Previous</span>
                                        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
                                        </svg>
                                    </a>
                                    <a href="#" class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-primary text-sm font-medium text-white">
                                        1
                                    </a>
                                    <a href="#" class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50 dark:bg-gray-800 dark:border-gray-600 dark:text-gray-300 dark:hover:bg-gray-700">
                                        2
                                    </a>
                                    <a href="#" class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50 dark:bg-gray-800 dark:border-gray-600 dark:text-gray-300 dark:hover:bg-gray-700">
                                        3
                                    </a>
                                    <span class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700 dark:bg-gray-800 dark:border-gray-600 dark:text-gray-300">
                                        ...
                                    </span>
                                    <a href="#" class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50 dark:bg-gray-800 dark:border-gray-600 dark:text-gray-300 dark:hover:bg-gray-700">
                                        8
                                    </a>
                                    <a href="#" class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50 dark:bg-gray-800 dark:border-gray-600 dark:text-gray-300 dark:hover:bg-gray-700">
                                        9
                                    </a>
                                    <a href="#" class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50 dark:bg-gray-800 dark:border-gray-600 dark:text-gray-300 dark:hover:bg-gray-700">
                                        10
                                    </a>
                                    <a href="#" class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 dark:bg-gray-800 dark:border-gray-600 dark:hover:bg-gray-700">
                                        <span class="sr-only">Next</span>
                                        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                                        </svg>
                                    </a>
                                </nav>
                            </div>
                        </div>
                    </nav>
                </div>
            </section>
            
            <!-- Feedback Section -->
            <section id="feedback" class="mb-16">
                <h2 class="text-3xl font-bold mb-8">Feedback</h2>
                
                <!-- Alerts -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Alerts</h3>
                    <div class="space-y-4">
                        <div class="p-4 bg-blue-100 border border-blue-400 text-blue-700 rounded-md dark:bg-blue-900/20 dark:border-blue-800 dark:text-blue-400">
                            <div class="flex">
                                <svg class="flex-shrink-0 h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd"/>
                                </svg>
                                <div class="ml-3">
                                    <p class="text-sm">Information alert! This is some informative text.</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="p-4 bg-green-100 border border-green-400 text-green-700 rounded-md dark:bg-green-900/20 dark:border-green-800 dark:text-green-400">
                            <div class="flex">
                                <svg class="flex-shrink-0 h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                                </svg>
                                <div class="ml-3">
                                    <p class="text-sm">Success! Your action was completed successfully.</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="p-4 bg-yellow-100 border border-yellow-400 text-yellow-800 rounded-md dark:bg-yellow-900/20 dark:border-yellow-800 dark:text-yellow-400">
                            <div class="flex">
                                <svg class="flex-shrink-0 h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/>
                                </svg>
                                <div class="ml-3">
                                    <p class="text-sm">Warning! Please check your input.</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="p-4 bg-red-100 border border-red-400 text-red-700 rounded-md dark:bg-red-900/20 dark:border-red-800 dark:text-red-400">
                            <div class="flex">
                                <svg class="flex-shrink-0 h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"/>
                                </svg>
                                <div class="ml-3">
                                    <p class="text-sm">Error! Something went wrong.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Toasts -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Toast Notifications</h3>
                    <button onclick="showToast()" class="px-4 py-2 bg-primary text-white rounded-md hover:bg-primary/90">
                        Show Toast
                    </button>
                    <div id="toast" class="fixed top-4 right-4 hidden">
                        <div class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg shadow-lg p-4 max-w-sm">
                            <div class="flex items-start">
                                <div class="flex-shrink-0">
                                    <svg class="h-6 w-6 text-green-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                    </svg>
                                </div>
                                <div class="ml-3 w-0 flex-1">
                                    <p class="text-sm font-medium text-gray-900 dark:text-white">
                                        Successfully saved!
                                    </p>
                                    <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                        Your changes have been saved.
                                    </p>
                                </div>
                                <div class="ml-4 flex-shrink-0 flex">
                                    <button onclick="hideToast()" class="inline-flex text-gray-400 hover:text-gray-500">
                                        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                                        </svg>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Tooltips -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Tooltips</h3>
                    <div class="flex gap-4">
                        <div class="relative group">
                            <button class="px-4 py-2 bg-gray-200 dark:bg-gray-700 rounded-md">
                                Hover me (top)
                            </button>
                            <div class="absolute bottom-full left-1/2 transform -translate-x-1/2 mb-2 px-3 py-1 bg-gray-900 text-white text-sm rounded-md opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none">
                                Tooltip on top
                                <div class="absolute top-full left-1/2 transform -translate-x-1/2 -mt-1">
                                    <div class="border-4 border-transparent border-t-gray-900"></div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="relative group">
                            <button class="px-4 py-2 bg-gray-200 dark:bg-gray-700 rounded-md">
                                Hover me (bottom)
                            </button>
                            <div class="absolute top-full left-1/2 transform -translate-x-1/2 mt-2 px-3 py-1 bg-gray-900 text-white text-sm rounded-md opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none">
                                Tooltip on bottom
                                <div class="absolute bottom-full left-1/2 transform -translate-x-1/2 -mb-1">
                                    <div class="border-4 border-transparent border-b-gray-900"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Progress Bars -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Progress Bars</h3>
                    <div class="space-y-4 max-w-md">
                        <div>
                            <div class="flex justify-between mb-1">
                                <span class="text-sm font-medium">Progress</span>
                                <span class="text-sm font-medium">25%</span>
                            </div>
                            <div class="w-full bg-gray-200 rounded-full h-2.5 dark:bg-gray-700">
                                <div class="bg-primary h-2.5 rounded-full" style="width: 25%"></div>
                            </div>
                        </div>
                        <div>
                            <div class="flex justify-between mb-1">
                                <span class="text-sm font-medium">Progress</span>
                                <span class="text-sm font-medium">50%</span>
                            </div>
                            <div class="w-full bg-gray-200 rounded-full h-2.5 dark:bg-gray-700">
                                <div class="bg-green-600 h-2.5 rounded-full" style="width: 50%"></div>
                            </div>
                        </div>
                        <div>
                            <div class="flex justify-between mb-1">
                                <span class="text-sm font-medium">Progress</span>
                                <span class="text-sm font-medium">75%</span>
                            </div>
                            <div class="w-full bg-gray-200 rounded-full h-2.5 dark:bg-gray-700">
                                <div class="bg-yellow-400 h-2.5 rounded-full" style="width: 75%"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            
            <!-- Data Display Section -->
            <section id="data-display" class="mb-16">
                <h2 class="text-3xl font-bold mb-8">Data Display</h2>
                
                <!-- Cards -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Cards</h3>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                        <div class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg p-6">
                            <h4 class="text-lg font-semibold mb-2">Basic Card</h4>
                            <p class="text-gray-600 dark:text-gray-400">This is a basic card with some content inside it.</p>
                        </div>
                        
                        <div class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg shadow-md p-6">
                            <h4 class="text-lg font-semibold mb-2">Card with Shadow</h4>
                            <p class="text-gray-600 dark:text-gray-400">This card has a shadow for more depth.</p>
                        </div>
                        
                        <div class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg p-6 hover:shadow-lg transition-shadow cursor-pointer">
                            <h4 class="text-lg font-semibold mb-2">Interactive Card</h4>
                            <p class="text-gray-600 dark:text-gray-400">Hover over this card to see the effect.</p>
                        </div>
                    </div>
                </div>
                
                <!-- Tables -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Tables</h3>
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
                            <thead class="bg-gray-50 dark:bg-gray-800">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                                        Name
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                                        Email
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                                        Role
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                                        Status
                                    </th>
                                    <th class="relative px-6 py-3">
                                        <span class="sr-only">Actions</span>
                                    </th>
                                </tr>
                            </thead>
                            <tbody class="bg-white dark:bg-gray-900 divide-y divide-gray-200 dark:divide-gray-700">
                                <tr class="hover:bg-gray-50 dark:hover:bg-gray-800">
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="flex items-center">
                                            <div class="flex-shrink-0 h-10 w-10">
                                                <div class="h-10 w-10 rounded-full bg-gray-300 dark:bg-gray-600"></div>
                                            </div>
                                            <div class="ml-4">
                                                <div class="text-sm font-medium text-gray-900 dark:text-white">
                                                    John Doe
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="text-sm text-gray-900 dark:text-gray-300">john@example.com</div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="text-sm text-gray-900 dark:text-gray-300">Administrator</div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800 dark:bg-green-900/20 dark:text-green-400">
                                            Active
                                        </span>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                        <a href="#" class="text-primary hover:text-primary/80">Edit</a>
                                    </td>
                                </tr>
                                <tr class="hover:bg-gray-50 dark:hover:bg-gray-800">
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="flex items-center">
                                            <div class="flex-shrink-0 h-10 w-10">
                                                <div class="h-10 w-10 rounded-full bg-gray-300 dark:bg-gray-600"></div>
                                            </div>
                                            <div class="ml-4">
                                                <div class="text-sm font-medium text-gray-900 dark:text-white">
                                                    Jane Smith
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="text-sm text-gray-900 dark:text-gray-300">jane@example.com</div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="text-sm text-gray-900 dark:text-gray-300">Editor</div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300">
                                            Inactive
                                        </span>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                        <a href="#" class="text-primary hover:text-primary/80">Edit</a>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <!-- Badges -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Badges & Pills</h3>
                    <div class="flex flex-wrap gap-2">
                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300">
                            Default
                        </span>
                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800 dark:bg-blue-900/20 dark:text-blue-400">
                            Primary
                        </span>
                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800 dark:bg-green-900/20 dark:text-green-400">
                            Success
                        </span>
                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800 dark:bg-yellow-900/20 dark:text-yellow-400">
                            Warning
                        </span>
                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800 dark:bg-red-900/20 dark:text-red-400">
                            Danger
                        </span>
                        <span class="inline-flex items-center px-3 py-0.5 rounded-full text-xs font-medium bg-primary text-white">
                            <svg class="-ml-0.5 mr-1.5 h-2 w-2" fill="currentColor" viewBox="0 0 8 8">
                                <circle cx="4" cy="4" r="3"/>
                            </svg>
                            With Icon
                        </span>
                    </div>
                </div>
                
                <!-- Avatars -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Avatars</h3>
                    <div class="flex items-center space-x-4">
                        <div class="h-8 w-8 rounded-full bg-gray-300 dark:bg-gray-600"></div>
                        <div class="h-10 w-10 rounded-full bg-gray-300 dark:bg-gray-600"></div>
                        <div class="h-12 w-12 rounded-full bg-gray-300 dark:bg-gray-600"></div>
                        <div class="h-16 w-16 rounded-full bg-gray-300 dark:bg-gray-600"></div>
                        <div class="relative h-12 w-12">
                            <div class="h-12 w-12 rounded-full bg-gray-300 dark:bg-gray-600"></div>
                            <div class="absolute bottom-0 right-0 h-3.5 w-3.5 rounded-full border-2 border-white dark:border-gray-900 bg-green-400"></div>
                        </div>
                    </div>
                </div>
            </section>
            
            <!-- Overlays Section -->
            <section id="overlays" class="mb-16">
                <h2 class="text-3xl font-bold mb-8">Overlays</h2>
                
                <!-- Modal -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Modal</h3>
                    <button onclick="openModal()" class="px-4 py-2 bg-primary text-white rounded-md hover:bg-primary/90">
                        Open Modal
                    </button>
                    
                    <!-- Modal backdrop -->
                    <div id="modal" class="hidden fixed inset-0 z-50 overflow-y-auto">
                        <div class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
                            <div class="fixed inset-0 transition-opacity" aria-hidden="true">
                                <div class="absolute inset-0 bg-gray-500 opacity-75"></div>
                            </div>
                            
                            <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>
                            
                            <div class="inline-block align-bottom bg-white dark:bg-gray-800 rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
                                <div class="bg-white dark:bg-gray-800 px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                                    <div class="sm:flex sm:items-start">
                                        <div class="mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full bg-blue-100 dark:bg-blue-900/20 sm:mx-0 sm:h-10 sm:w-10">
                                            <svg class="h-6 w-6 text-blue-600 dark:text-blue-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                            </svg>
                                        </div>
                                        <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
                                            <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-white">
                                                Modal Title
                                            </h3>
                                            <div class="mt-2">
                                                <p class="text-sm text-gray-500 dark:text-gray-400">
                                                    This is a modal dialog. You can put any content here.
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="bg-gray-50 dark:bg-gray-900 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
                                    <button type="button" onclick="closeModal()" class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-primary text-base font-medium text-white hover:bg-primary/90 sm:ml-3 sm:w-auto sm:text-sm">
                                        Confirm
                                    </button>
                                    <button type="button" onclick="closeModal()" class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white dark:bg-gray-800 text-base font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">
                                        Cancel
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Dropdown -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Dropdown Menu</h3>
                    <div class="relative inline-block text-left">
                        <button onclick="toggleDropdown()" class="inline-flex justify-center w-full rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white dark:bg-gray-800 text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700">
                            Options
                            <svg class="-mr-1 ml-2 h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                            </svg>
                        </button>
                        
                        <div id="dropdown" class="hidden origin-top-right absolute right-0 mt-2 w-56 rounded-md shadow-lg bg-white dark:bg-gray-800 ring-1 ring-black ring-opacity-5">
                            <div class="py-1" role="menu">
                                <a href="#" class="block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">Account settings</a>
                                <a href="#" class="block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">Support</a>
                                <a href="#" class="block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">License</a>
                                <hr class="my-1 border-gray-200 dark:border-gray-700">
                                <a href="#" class="block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">Sign out</a>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            
            <!-- States Section -->
            <section id="states" class="mb-16">
                <h2 class="text-3xl font-bold mb-8">States</h2>
                
                <!-- Loading States -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Loading States</h3>
                    <div class="space-y-6">
                        <!-- Spinner -->
                        <div>
                            <h4 class="font-medium mb-2">Spinner</h4>
                            <div class="flex space-x-4">
                                <svg class="animate-spin h-5 w-5 text-primary" fill="none" viewBox="0 0 24 24">
                                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                                </svg>
                                <svg class="animate-spin h-8 w-8 text-primary" fill="none" viewBox="0 0 24 24">
                                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                                </svg>
                                <svg class="animate-spin h-12 w-12 text-primary" fill="none" viewBox="0 0 24 24">
                                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                                </svg>
                            </div>
                        </div>
                        
                        <!-- Skeleton -->
                        <div>
                            <h4 class="font-medium mb-2">Skeleton Loader</h4>
                            <div class="animate-pulse">
                                <div class="flex space-x-4">
                                    <div class="rounded-full bg-gray-300 dark:bg-gray-700 h-10 w-10"></div>
                                    <div class="flex-1 space-y-2 py-1">
                                        <div class="h-4 bg-gray-300 dark:bg-gray-700 rounded w-3/4"></div>
                                        <div class="h-4 bg-gray-300 dark:bg-gray-700 rounded w-1/2"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Loading Button -->
                        <div>
                            <h4 class="font-medium mb-2">Loading Button</h4>
                            <button class="inline-flex items-center px-4 py-2 bg-primary text-white rounded-md" disabled>
                                <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" fill="none" viewBox="0 0 24 24">
                                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                                </svg>
                                Processing...
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Empty States -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Empty States</h3>
                    <div class="border-2 border-dashed border-gray-300 dark:border-gray-700 rounded-lg p-12 text-center">
                        <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 13h6m-3-3v6m-9 1V7a2 2 0 012-2h6l2 2h6a2 2 0 012 2v8a2 2 0 01-2 2H5a2 2 0 01-2-2z"/>
                        </svg>
                        <h3 class="mt-2 text-sm font-medium text-gray-900 dark:text-white">No data</h3>
                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">Get started by creating a new item.</p>
                        <div class="mt-6">
                            <button class="inline-flex items-center px-4 py-2 bg-primary text-white rounded-md hover:bg-primary/90">
                                <svg class="-ml-1 mr-2 h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                                </svg>
                                New Item
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Error States -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Error States</h3>
                    <div class="bg-red-50 dark:bg-red-900/10 border border-red-200 dark:border-red-900 rounded-lg p-8 text-center">
                        <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-red-100 dark:bg-red-900/20">
                            <svg class="h-6 w-6 text-red-600 dark:text-red-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
                            </svg>
                        </div>
                        <h3 class="mt-2 text-sm font-medium text-red-800 dark:text-red-400">Error loading data</h3>
                        <p class="mt-1 text-sm text-red-600 dark:text-red-300">Something went wrong. Please try again.</p>
                        <div class="mt-6">
                            <button class="inline-flex items-center px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700">
                                Try Again
                            </button>
                        </div>
                    </div>
                </div>
            </section>
            
            <!-- Miscellaneous Section -->
            <section id="misc" class="mb-16">
                <h2 class="text-3xl font-bold mb-8">Miscellaneous</h2>
                
                <!-- Accordion -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Accordion</h3>
                    <div class="space-y-2 max-w-2xl">
                        <div class="border border-gray-200 dark:border-gray-700 rounded-md">
                            <button onclick="toggleAccordion(1)" class="w-full px-4 py-3 text-left flex justify-between items-center hover:bg-gray-50 dark:hover:bg-gray-800">
                                <span class="font-medium">Accordion Item 1</span>
                                <svg class="h-5 w-5 transform transition-transform" id="accordion-icon-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                                </svg>
                            </button>
                            <div id="accordion-content-1" class="hidden px-4 py-3 border-t border-gray-200 dark:border-gray-700">
                                <p class="text-gray-600 dark:text-gray-400">This is the content of accordion item 1. You can put any content here.</p>
                            </div>
                        </div>
                        <div class="border border-gray-200 dark:border-gray-700 rounded-md">
                            <button onclick="toggleAccordion(2)" class="w-full px-4 py-3 text-left flex justify-between items-center hover:bg-gray-50 dark:hover:bg-gray-800">
                                <span class="font-medium">Accordion Item 2</span>
                                <svg class="h-5 w-5 transform transition-transform" id="accordion-icon-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                                </svg>
                            </button>
                            <div id="accordion-content-2" class="hidden px-4 py-3 border-t border-gray-200 dark:border-gray-700">
                                <p class="text-gray-600 dark:text-gray-400">This is the content of accordion item 2. You can put any content here.</p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Stepper -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Stepper</h3>
                    <ol class="flex items-center w-full">
                        <li class="flex w-full items-center text-blue-600 dark:text-blue-500 after:content-[''] after:w-full after:h-1 after:border-b after:border-blue-100 after:border-4 after:inline-block dark:after:border-blue-800">
                            <span class="flex items-center justify-center w-10 h-10 bg-blue-100 rounded-full dark:bg-blue-800">
                                <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                                </svg>
                            </span>
                        </li>
                        <li class="flex w-full items-center after:content-[''] after:w-full after:h-1 after:border-b after:border-gray-100 after:border-4 after:inline-block dark:after:border-gray-700">
                            <span class="flex items-center justify-center w-10 h-10 bg-gray-100 rounded-full dark:bg-gray-700">
                                <span class="text-gray-500 dark:text-gray-400">2</span>
                            </span>
                        </li>
                        <li class="flex items-center">
                            <span class="flex items-center justify-center w-10 h-10 bg-gray-100 rounded-full dark:bg-gray-700">
                                <span class="text-gray-500 dark:text-gray-400">3</span>
                            </span>
                        </li>
                    </ol>
                </div>
                
                <!-- Dividers -->
                <div class="mb-8">
                    <h3 class="text-xl font-semibold mb-4">Dividers</h3>
                    <div class="space-y-8">
                        <hr class="border-gray-200 dark:border-gray-700">
                        
                        <div class="relative">
                            <div class="absolute inset-0 flex items-center">
                                <div class="w-full border-t border-gray-300 dark:border-gray-700"></div>
                            </div>
                            <div class="relative flex justify-center text-sm">
                                <span class="px-2 bg-white dark:bg-gray-900 text-gray-500">OR</span>
                            </div>
                        </div>
                        
                        <div class="relative">
                            <div class="absolute inset-0 flex items-center">
                                <div class="w-full border-t border-gray-300 dark:border-gray-700"></div>
                            </div>
                            <div class="relative flex justify-center text-sm">
                                <span class="px-2 bg-white dark:bg-gray-900 text-gray-500">Continue with</span>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            
        </main>
    </div>
    
    <!-- JavaScript -->
    <script>
        // Dark mode toggle
        const darkModeToggle = document.getElementById('darkModeToggle');
        const html = document.documentElement;
        
        darkModeToggle.addEventListener('click', () => {
            html.classList.toggle('dark');
            localStorage.setItem('darkMode', html.classList.contains('dark'));
        });
        
        // Check for saved dark mode preference
        if (localStorage.getItem('darkMode') === 'true') {
            html.classList.add('dark');
        }
        
        // Toast functions
        function showToast() {
            const toast = document.getElementById('toast');
            toast.classList.remove('hidden');
            setTimeout(() => {
                hideToast();
            }, 5000);
        }
        
        function hideToast() {
            const toast = document.getElementById('toast');
            toast.classList.add('hidden');
        }
        
        // Modal functions
        function openModal() {
            document.getElementById('modal').classList.remove('hidden');
        }
        
        function closeModal() {
            document.getElementById('modal').classList.add('hidden');
        }
        
        // Dropdown function
        function toggleDropdown() {
            document.getElementById('dropdown').classList.toggle('hidden');
        }
        
        // Accordion function
        function toggleAccordion(id) {
            const content = document.getElementById(`accordion-content-${id}`);
            const icon = document.getElementById(`accordion-icon-${id}`);
            
            content.classList.toggle('hidden');
            icon.classList.toggle('rotate-180');
        }
        
        // Close dropdown when clicking outside
        window.addEventListener('click', (e) => {
            if (!e.target.matches('.dropdown-button')) {
                const dropdown = document.getElementById('dropdown');
                if (dropdown && !dropdown.classList.contains('hidden')) {
                    dropdown.classList.add('hidden');
                }
            }
        });
    </script>
</body>
</html>
```
</html_template>

<implementation_instructions>
When generating the HTML file:

1. **Extract Design Tokens**: Carefully read the style guide and extract:
   - Exact color values (replace [PRIMARY_COLOR], [SECONDARY_COLOR], etc.)
   - Typography settings (font families, sizes, weights)
   - Spacing values
   - Animation settings
   - Any custom CSS needed

2. **Follow Brand Guidelines**: 
   - Apply the tone and personality from the style guide
   - Use appropriate language in UI copy
   - Maintain consistency with the brand voice

3. **Component Implementation**:
   - Every component must match the specifications in the style guide exactly
   - Use Tailwind CSS utilities wherever possible
   - Add custom CSS only when Tailwind cannot achieve the design
   - Ensure all interactive states are implemented

4. **Responsive Design**:
   - Test all components at different breakpoints
   - Ensure mobile-first approach
   - Follow the grid system from the style guide

5. **Accessibility**:
   - Include proper ARIA labels
   - Ensure keyboard navigation works
   - Maintain color contrast ratios from the guide
   - Add screen reader support

6. **Dark Mode**:
   - Implement all dark mode colors from the style guide
   - Ensure smooth transitions between modes
   - Test all components in both light and dark modes

7. **Interactive Features**:
   - All JavaScript should be vanilla JS (no frameworks)
   - Ensure smooth animations and transitions
   - Handle edge cases gracefully
</implementation_instructions>

<additional_components>
Also include these components that are commonly needed:

1. **Date/Time Pickers**: Calendar widget and time selector
2. **Sliders/Range Inputs**: For numeric value selection
3. **Autocomplete/Combobox**: Searchable dropdown
4. **Tags Input**: Multi-select with tag creation
5. **Code Blocks**: Syntax highlighted code display
6. **Timeline**: Vertical/horizontal timeline component
7. **Stats Cards**: Dashboard-style metric displays
8. **Navigation Drawer**: Mobile-style slide-out menu
9. **Image Gallery**: Grid/carousel image display
10. **Rating Component**: Star ratings
11. **Copy to Clipboard**: Button with feedback
12. **Floating Action Button**: Material-style FAB
13. **Context Menu**: Right-click menu
14. **Sidebar Layouts**: Fixed and collapsible sidebars
15. **Footer Examples**: Various footer layouts
</additional_components>

<verification>
After generating the HTML file, verify:

1. **Style Guide Compliance**: Every color, font, spacing matches the guide
2. **Component Completeness**: All requested components are present
3. **Interactive Functionality**: All buttons, modals, toggles work
4. **Dark Mode**: Everything looks good in both themes
5. **Responsive Design**: Components adapt properly to screen sizes
6. **Code Quality**: Clean, well-commented, organized code
7. **Accessibility**: Keyboard navigation and screen reader support
8. **Performance**: Smooth animations and transitions
9. **Cross-browser**: Works in major browsers
10. **Tailwind Usage**: Maximizes utility classes, minimal custom CSS
</verification>