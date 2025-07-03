#!/bin/bash
# clear-logs.sh - Clears all Claude Code hook log files
# Usage: ./clear-logs.sh [--backup]

# Configuration
LOG_DIR="$HOME/.claude/logs"
BACKUP_DIR="$HOME/.claude/logs/backups"

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Parse command line arguments
BACKUP=false
if [[ "$1" == "--backup" ]]; then
    BACKUP=true
fi

echo "===================="
echo "Claude Code Log Cleaner"
echo "===================="
echo ""

# Check if log directory exists
if [[ ! -d "$LOG_DIR" ]]; then
    echo -e "${RED}Log directory not found: $LOG_DIR${NC}"
    echo "No logs to clear."
    exit 0
fi

# List of log files created by hooks
LOG_FILES=(
    "auto-approve.log"
    "auto-blocked.log"
    "dangerous-commands.log"
    "approval-notifications.log"
    "completion.log"
)

# Count total size before clearing
TOTAL_SIZE=0
for log_file in "${LOG_FILES[@]}"; do
    if [[ -f "$LOG_DIR/$log_file" ]]; then
        SIZE=$(stat -f%z "$LOG_DIR/$log_file" 2>/dev/null || stat -c%s "$LOG_DIR/$log_file" 2>/dev/null || echo 0)
        TOTAL_SIZE=$((TOTAL_SIZE + SIZE))
    fi
done

# Convert size to human readable format
if [[ $TOTAL_SIZE -gt 1048576 ]]; then
    HUMAN_SIZE=$(echo "scale=2; $TOTAL_SIZE / 1048576" | bc)
    SIZE_UNIT="MB"
elif [[ $TOTAL_SIZE -gt 1024 ]]; then
    HUMAN_SIZE=$(echo "scale=2; $TOTAL_SIZE / 1024" | bc)
    SIZE_UNIT="KB"
else
    HUMAN_SIZE=$TOTAL_SIZE
    SIZE_UNIT="bytes"
fi

echo -e "Total log size: ${YELLOW}${HUMAN_SIZE} ${SIZE_UNIT}${NC}"
echo ""

# Backup logs if requested
if [[ "$BACKUP" == "true" ]]; then
    echo "Creating backup..."
    mkdir -p "$BACKUP_DIR"
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_FILE="$BACKUP_DIR/logs_backup_$TIMESTAMP.tar.gz"
    
    # Create tar archive of log files
    cd "$LOG_DIR"
    tar -czf "$BACKUP_FILE" "${LOG_FILES[@]}" 2>/dev/null
    
    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}✓ Backup created: $BACKUP_FILE${NC}"
    else
        echo -e "${YELLOW}⚠ Some log files were not found for backup${NC}"
    fi
    echo ""
fi

# Clear each log file
echo "Clearing log files..."
CLEARED_COUNT=0
NOT_FOUND_COUNT=0

for log_file in "${LOG_FILES[@]}"; do
    if [[ -f "$LOG_DIR/$log_file" ]]; then
        > "$LOG_DIR/$log_file"
        echo -e "${GREEN}✓ Cleared: $log_file${NC}"
        CLEARED_COUNT=$((CLEARED_COUNT + 1))
    else
        echo -e "${YELLOW}⚠ Not found: $log_file${NC}"
        NOT_FOUND_COUNT=$((NOT_FOUND_COUNT + 1))
    fi
done

echo ""
echo "===================="
echo -e "${GREEN}Summary:${NC}"
echo -e "- Cleared: ${GREEN}$CLEARED_COUNT${NC} log files"
if [[ $NOT_FOUND_COUNT -gt 0 ]]; then
    echo -e "- Not found: ${YELLOW}$NOT_FOUND_COUNT${NC} log files"
fi
if [[ "$BACKUP" == "true" ]]; then
    echo -e "- Backup saved to: ${GREEN}$BACKUP_FILE${NC}"
fi
echo -e "- Space freed: ${GREEN}${HUMAN_SIZE} ${SIZE_UNIT}${NC}"
echo "===================="
echo ""
echo "Log files have been cleared successfully!"
echo ""
echo "Tips:"
echo "- Use './clear-logs.sh --backup' to backup logs before clearing"
echo "- Check ~/.claude/logs/backups/ for archived logs"
echo "- Logs will start accumulating again as hooks run"