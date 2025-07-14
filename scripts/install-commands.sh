#!/bin/bash
# Claude Code Goodies - Commands Installation Script
# This script copies all commands to the Claude Code commands directory

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
COMMANDS_SOURCE="$PROJECT_ROOT/commands"
CLAUDE_DIR="$HOME/.claude"
COMMANDS_DEST="$CLAUDE_DIR/commands"

echo "Claude Code Goodies - Commands Installation"
echo "==========================================="
echo ""

# Check if commands directory exists in project
if [ ! -d "$COMMANDS_SOURCE" ]; then
    echo -e "${RED}Error: commands directory not found at $COMMANDS_SOURCE${NC}"
    exit 1
fi

# Create Claude commands directory if it doesn't exist
echo "Creating Claude Code commands directory..."
mkdir -p "$COMMANDS_DEST"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Commands directory created/verified${NC}"
else
    echo -e "${RED}✗ Failed to create commands directory${NC}"
    exit 1
fi

# Copy all command files
echo ""
echo "Copying command files..."

# Count files to copy (including subdirectories)
FILE_COUNT=$(find "$COMMANDS_SOURCE" -name "*.md" -type f | wc -l)

if [ $FILE_COUNT -eq 0 ]; then
    echo -e "${YELLOW}! No command files found to copy${NC}"
    exit 0
fi

echo "Found $FILE_COUNT command file(s) to copy..."

# Copy markdown command files while preserving directory structure
cd "$COMMANDS_SOURCE"
find . -name "*.md" -type f | while read -r file; do
    # Get the directory path and create it in destination
    dir=$(dirname "$file")
    if [ "$dir" != "." ]; then
        mkdir -p "$COMMANDS_DEST/$dir"
    fi
    
    # Copy the file
    cp "$file" "$COMMANDS_DEST/$file"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Copied $file${NC}"
    else
        echo -e "${RED}✗ Failed to copy $file${NC}"
    fi
done
cd - > /dev/null

# Verify installation
echo ""
echo "Verifying installation..."
INSTALLED_COUNT=$(find "$COMMANDS_DEST" -name "*.md" -type f | wc -l)
if [ $INSTALLED_COUNT -gt 0 ]; then
    echo -e "${GREEN}✓ Successfully installed $INSTALLED_COUNT command(s)${NC}"
    echo ""
    echo "Installation complete! Your commands are now available."
    echo ""
    echo "Available commands:"
    cd "$COMMANDS_DEST"
    find . -name "*.md" -type f | sort | while read -r file; do
        # Remove leading ./ and .md extension
        command_path=${file#./}
        command_path=${command_path%.md}
        # Replace directory separators with /
        echo "  - /$command_path"
    done
    cd - > /dev/null
    echo ""
    echo "Usage:"
    echo "  Type /<command_name> in Claude Code to use a command"
    echo "  Example: /cpr - Commit, push and create PR"
    echo ""
    echo "Note: Commands are custom prompts that help automate common workflows"
else
    echo -e "${RED}✗ Installation may have failed - no commands found in destination${NC}"
    exit 1
fi