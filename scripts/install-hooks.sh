#!/bin/bash
# Claude Code Goodies - Hook Installation Script
# This script copies all hooks to the Claude Code hooks directory

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
HOOKS_SOURCE="$PROJECT_ROOT/hooks"
CLAUDE_DIR="$HOME/.claude"
HOOKS_DEST="$CLAUDE_DIR/hooks"
LOGS_DIR="$CLAUDE_DIR/logs"

echo "Claude Code Goodies - Hook Installation"
echo "======================================="
echo ""

# Check if hooks directory exists in project
if [ ! -d "$HOOKS_SOURCE" ]; then
    echo -e "${RED}Error: hooks directory not found at $HOOKS_SOURCE${NC}"
    exit 1
fi

# Create Claude directories if they don't exist
echo "Creating Claude Code directories..."
mkdir -p "$HOOKS_DEST" "$LOGS_DIR"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Directories created/verified${NC}"
else
    echo -e "${RED}✗ Failed to create directories${NC}"
    exit 1
fi

# Copy all hook files
echo ""
echo "Copying hook files..."

# Copy shell scripts
for file in "$HOOKS_SOURCE"/*.sh; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        cp "$file" "$HOOKS_DEST/"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Copied $filename${NC}"
            # Make executable
            chmod +x "$HOOKS_DEST/$filename"
        else
            echo -e "${RED}✗ Failed to copy $filename${NC}"
        fi
    fi
done

# Copy text configuration files
for file in "$HOOKS_SOURCE"/*.txt; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        cp "$file" "$HOOKS_DEST/"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Copied $filename${NC}"
        else
            echo -e "${RED}✗ Failed to copy $filename${NC}"
        fi
    fi
done

# Copy TypeScript hooks if they exist
if [ -d "$HOOKS_SOURCE/ts" ]; then
    echo ""
    echo "Copying TypeScript hooks..."
    
    # Copy the entire TypeScript directory structure
    cp -r "$HOOKS_SOURCE/ts" "$HOOKS_DEST/"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Copied TypeScript hooks directory${NC}"
        # Make all .ts files executable
        find "$HOOKS_DEST/ts" -name "*.ts" -type f -exec chmod +x {} \;
        
        # Count and display copied files
        TS_COUNT=$(find "$HOOKS_DEST/ts" -name "*.ts" -type f | wc -l)
        echo -e "${GREEN}✓ Installed $TS_COUNT TypeScript files${NC}"
    else
        echo -e "${RED}✗ Failed to copy TypeScript hooks${NC}"
    fi
fi

# Check if settings.json needs to be copied
echo ""
if [ ! -f "$CLAUDE_DIR/settings.json" ]; then
    if [ -f "$PROJECT_ROOT/settings.json.example" ]; then
        echo "Copying settings.json.example to ~/.claude/settings.json..."
        cp "$PROJECT_ROOT/settings.json.example" "$CLAUDE_DIR/settings.json"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Settings file created${NC}"
        else
            echo -e "${RED}✗ Failed to copy settings file${NC}"
        fi
    fi
else
    echo -e "${YELLOW}! Settings file already exists, skipping${NC}"
fi

# Check if .env needs to be copied
echo ""
if [ ! -f "$CLAUDE_DIR/.env" ]; then
    if [ -f "$PROJECT_ROOT/.env.example" ]; then
        echo "Creating .env configuration file..."
        cp "$PROJECT_ROOT/.env.example" "$CLAUDE_DIR/.env"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Created ~/.claude/.env from template${NC}"
            echo -e "${YELLOW}! IMPORTANT: Edit ~/.claude/.env to configure your preferences${NC}"
        else
            echo -e "${RED}✗ Failed to create .env file${NC}"
        fi
    fi
else
    echo -e "${YELLOW}! .env file already exists, skipping${NC}"
    echo -e "${YELLOW}! Your existing configuration has been preserved${NC}"
fi

# Verify installation
echo ""
echo "Verifying installation..."
# Count both shell scripts and TypeScript files
SH_COUNT=$(ls -1 "$HOOKS_DEST"/*.sh 2>/dev/null | wc -l)
TS_COUNT=$(find "$HOOKS_DEST/ts" -name "*.ts" -type f 2>/dev/null | wc -l)
TOTAL_COUNT=$((SH_COUNT + TS_COUNT))

if [ $TOTAL_COUNT -gt 0 ]; then
    echo -e "${GREEN}✓ Successfully installed:${NC}"
    [ $SH_COUNT -gt 0 ] && echo -e "${GREEN}  - $SH_COUNT shell scripts${NC}"
    [ $TS_COUNT -gt 0 ] && echo -e "${GREEN}  - $TS_COUNT TypeScript files${NC}"
    echo ""
    echo "Installation complete! Your hooks are now active."
    echo ""
    echo "Next steps:"
    echo "1. Configure settings (optional):"
    echo "   - Edit ~/.claude/.env"
    echo "   - Set your preferences for sound notifications"
    echo ""
    echo "2. Test the hooks:"
    echo "   - Try: echo 'Hello, World!' (should auto-approve)"
    echo "   - Try: rm -rf /tmp/test (should ask for permission)"
    echo ""
    echo "3. View logs:"
    echo "   - tail -f ~/.claude/logs/hooks/command-filter.log"
    echo "   - jq '.' ./logs/hooks/pre-tool-use.json"
    echo ""
    echo "4. To use advanced settings with all hooks enabled:"
    echo "   - Copy settings-advanced.json.example to ~/.claude/settings.json"
    echo "   - TypeScript hooks will log to ./logs/hooks/*.json"
    echo ""
    echo "5. To enable sound notifications (macOS):"
    echo "   - Add SOUND_NOTIFICATIONS_ENABLED=true to ~/.claude/.env"
    echo "   - Add sound-player.ts to your hooks in settings.json"
    echo "   - Different sounds play for different events (completion, notification, blocked, error)"
    echo "   - Customize sounds in ~/.claude/.env (see .env.example for options)"
else
    echo -e "${RED}✗ Installation may have failed - no scripts found in destination${NC}"
    exit 1
fi