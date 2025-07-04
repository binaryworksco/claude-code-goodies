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

# Count files to copy
FILE_COUNT=0
for file in "$COMMANDS_SOURCE"/*.md; do
    if [ -f "$file" ]; then
        ((FILE_COUNT++))
    fi
done

if [ $FILE_COUNT -eq 0 ]; then
    echo -e "${YELLOW}! No command files found to copy${NC}"
    exit 0
fi

# Copy markdown command files
for file in "$COMMANDS_SOURCE"/*.md; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        cp "$file" "$COMMANDS_DEST/"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Copied $filename${NC}"
        else
            echo -e "${RED}✗ Failed to copy $filename${NC}"
        fi
    fi
done

# Verify installation
echo ""
echo "Verifying installation..."
INSTALLED_COUNT=$(ls -1 "$COMMANDS_DEST"/*.md 2>/dev/null | wc -l)
if [ $INSTALLED_COUNT -gt 0 ]; then
    echo -e "${GREEN}✓ Successfully installed $INSTALLED_COUNT command(s)${NC}"
    echo ""
    echo "Installation complete! Your commands are now available."
    echo ""
    echo "Available commands:"
    for file in "$COMMANDS_DEST"/*.md; do
        if [ -f "$file" ]; then
            command_name=$(basename "$file" .md)
            echo "  - /$command_name"
        fi
    done
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