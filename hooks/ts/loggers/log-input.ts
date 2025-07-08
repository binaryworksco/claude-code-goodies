#!/usr/bin/env npx tsx
// Simple logger to capture raw input from Claude Code hooks

import * as fs from 'fs';
import * as path from 'path';

async function main() {
  try {
    // Read raw input from stdin
    let inputData = '';
    
    process.stdin.setEncoding('utf8');
    
    for await (const chunk of process.stdin) {
      inputData += chunk;
    }
    
    // Parse JSON
    let parsedInput: any;
    try {
      parsedInput = JSON.parse(inputData);
    } catch (e) {
      parsedInput = { 
        parseError: true, 
        rawInput: inputData,
        error: String(e)
      };
    }
    
    // Ensure log directory exists
    const logDir = path.join(process.cwd(), '.claude', 'logs', 'hooks');
    fs.mkdirSync(logDir, { recursive: true });
    
    // Write to log file
    const logFile = path.join(logDir, 'raw-input.json');
    
    // Read existing logs
    let logs: any[] = [];
    try {
      if (fs.existsSync(logFile)) {
        const content = fs.readFileSync(logFile, 'utf-8');
        logs = JSON.parse(content);
      }
    } catch (e) {
      // Start fresh if file is corrupted
      logs = [];
    }
    
    // Append just the parsed input (no wrapper)
    logs.push(parsedInput);
    
    // Write back
    fs.writeFileSync(logFile, JSON.stringify(logs, null, 2));
    
    // If this looks like a PreToolUse hook, return a response
    if (parsedInput && parsedInput.hook_event_name === 'PreToolUse') {
      process.stdout.write(JSON.stringify({
        info: "Logged by raw input logger"
      }));
    }
    
    process.exit(0);
  } catch (error) {
    // Log error to stderr but exit cleanly
    console.error('Logger error:', error);
    process.exit(0);
  }
}

main();