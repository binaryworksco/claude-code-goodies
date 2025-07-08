#!/usr/bin/env npx tsx
// SubagentStop hook - Logs when a subagent completes

import { HookLogger } from './lib/logger';
import { SubagentStopInput } from './lib/types';
import * as fs from 'fs';

async function main() {
  const logger = new HookLogger('subagent-stop');
  
  try {
    // Read input from stdin
    const input = await HookLogger.readStdin() as SubagentStopInput;
    
    // Don't run if already in a stop hook loop
    if (input.stop_hook_active === true) {
      process.exit(0);
    }
    
    // Enhanced logging for subagent stop hook
    const enhancedInput = { ...input };
    
    // If transcript_path is provided, try to read the full transcript
    if (input.transcript_path && fs.existsSync(input.transcript_path)) {
      try {
        // Read JSONL file line by line
        const transcriptContent = fs.readFileSync(input.transcript_path, 'utf-8');
        const messages = transcriptContent
          .split('\n')
          .filter(line => line.trim())
          .map(line => {
            try {
              return JSON.parse(line);
            } catch (e) {
              return null;
            }
          })
          .filter(msg => msg !== null);
        
        enhancedInput.transcript = { messages };
      } catch (error) {
        enhancedInput.transcript_read_error = `Failed to read transcript: ${error}`;
      }
    }
    
    // Log the enhanced input with subagent details
    logger.log(enhancedInput);
    
    // SubagentStop hooks don't need to return anything
    process.exit(0);
  } catch (error) {
    // Log error but don't interrupt Claude Code
    console.error('SubagentStop hook error:', error);
    process.exit(0);
  }
}

// Run the hook
main().catch((error) => {
  console.error('Unexpected error:', error);
  process.exit(0); // Always exit cleanly
});