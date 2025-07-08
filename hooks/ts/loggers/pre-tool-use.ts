#!/usr/bin/env npx tsx
// Pre-tool-use hook - Logs all tool usage requests before they execute

import { HookLogger } from './lib/logger';
import { PreToolUseInput, PreToolUseDecision } from './lib/types';

async function main() {
  const logger = new HookLogger('pre-tool-use');
  
  try {
    // Read input from stdin
    const input = await HookLogger.readStdin() as PreToolUseInput;
    
    // Log the input
    logger.log(input);
    
    // For logging-only mode, return empty response (undefined decision)
    // This allows Claude Code's normal permission flow to continue
    const response: PreToolUseDecision = {
      info: 'Logged by TypeScript pre-tool-use hook'
    };
    
    HookLogger.writeResponse(response);
  } catch (error) {
    // On error, still return a valid response to not break Claude Code
    const errorResponse: PreToolUseDecision = {
      info: `Hook error: ${error}`
    };
    HookLogger.writeResponse(errorResponse);
    process.exit(0); // Exit cleanly even on error
  }
}

// Run the hook
main().catch((error) => {
  console.error('Unexpected error:', error);
  process.exit(1);
});