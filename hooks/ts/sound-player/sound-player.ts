#!/usr/bin/env bun
// Universal sound player hook - Plays WAV files based on hook type

import { spawn } from 'child_process';
import * as fs from 'fs';
import * as path from 'path';
import * as os from 'os';

// Generic hook input interface
interface HookInput {
  hook_event_name?: string;
  stop_hook_active?: boolean;
  [key: string]: any;
}

// PreToolUse specific input
interface PreToolUseInput extends HookInput {
  hook_event_name: 'PreToolUse';
  tool_name: string;
  tool_input: Record<string, any>;
}

// Sound configuration mapping
interface SoundConfig {
  SOUND_NOTIFICATIONS_ENABLED?: string;
  STOP_SOUND?: string;
  NOTIFICATION_SOUND?: string;
  PRETOOLUSE_BLOCK_SOUND?: string;
  ERROR_SOUND?: string;
  // Legacy support
  COMPLETION_SOUND?: string;
}

// Default WAV files for different events
const DEFAULT_WAVS = {
  Stop: 'mixkit-happy-bell-alert.wav',
  Notification: 'mixkit-happy-bell-alert.wav',
  PreToolUseBlock: 'mixkit-happy-bell-alert.wav',
  Error: 'mixkit-happy-bell-alert.wav'
};

// Load environment configuration
function loadEnvConfig(): SoundConfig {
  const envPath = path.join(os.homedir(), '.claude', '.env');
  const config: SoundConfig = {};
  
  try {
    if (fs.existsSync(envPath)) {
      const content = fs.readFileSync(envPath, 'utf-8');
      content.split('\n').forEach(line => {
        const trimmed = line.trim();
        if (trimmed && !trimmed.startsWith('#')) {
          // Find the first = sign
          const equalIndex = trimmed.indexOf('=');
          if (equalIndex > 0) {
            const key = trimmed.substring(0, equalIndex).trim();
            let value = trimmed.substring(equalIndex + 1).trim();
            
            // Remove quotes from value if present
            value = value.replace(/^["']|["']$/g, '');
            
            // Remove inline comments
            const commentIndex = value.indexOf('#');
            if (commentIndex > 0) {
              value = value.substring(0, commentIndex).trim();
            }
            
            config[key as keyof SoundConfig] = value;
          }
        }
      });
    }
  } catch (error) {
    console.error('Error loading .env:', error);
  }
  
  return config;
}

// Read input from stdin
async function readStdin(): Promise<HookInput> {
  return new Promise((resolve, reject) => {
    let data = '';
    
    process.stdin.setEncoding('utf8');
    
    process.stdin.on('data', (chunk) => {
      data += chunk;
    });
    
    process.stdin.on('end', () => {
      try {
        const parsed = JSON.parse(data);
        resolve(parsed);
      } catch (error) {
        reject(new Error(`Failed to parse JSON input: ${error}`));
      }
    });
    
    process.stdin.on('error', reject);
  });
}

// Check if PreToolUse was blocked by reading command-filter decision
function wasCommandBlocked(input: PreToolUseInput): boolean {
  try {
    // Check for decision in the input if command-filter adds it
    if ('decision' in input && input.decision === 'block') {
      return true;
    }
    
    // Could also check command-filter.log but that would be more complex
    // and might have race conditions
    return false;
  } catch (error) {
    return false;
  }
}

// Get the WAV file path based on configuration
function getWavFilePath(wavFileName: string): string {
  // Get the directory where this script is located
  const scriptDir = path.dirname(new URL(import.meta.url).pathname);
  
  // Check if it's an absolute path
  if (path.isAbsolute(wavFileName)) {
    return wavFileName;
  }
  
  // Otherwise, look in the wav subdirectory
  return path.join(scriptDir, 'wav', wavFileName);
}

// Get the WAV filename for the given hook type and configuration
function getWavForHook(hookType: string, config: SoundConfig, input: HookInput): string | null {
  // Check if sound notifications are enabled
  const soundEnabled = config.SOUND_NOTIFICATIONS_ENABLED?.toLowerCase() !== 'false';
  if (!soundEnabled) {
    return null;
  }
  
  switch (hookType) {
    case 'Stop':
      // Use STOP_SOUND or fall back to COMPLETION_SOUND for backward compatibility
      return config.STOP_SOUND || config.COMPLETION_SOUND || DEFAULT_WAVS.Stop;
      
    case 'Notification':
      return config.NOTIFICATION_SOUND || DEFAULT_WAVS.Notification;
      
    case 'PreToolUse':
      // Only play sound if command was blocked
      const preToolInput = input as PreToolUseInput;
      if (wasCommandBlocked(preToolInput)) {
        return config.PRETOOLUSE_BLOCK_SOUND || DEFAULT_WAVS.PreToolUseBlock;
      }
      return null;
      
    case 'PostToolUse':
      // Check for errors in tool_response
      if (input.tool_error) {
        return config.ERROR_SOUND || DEFAULT_WAVS.Error;
      }
      return null;
      
    default:
      // Unknown hook type
      return null;
  }
}

// Detect if running under WSL
function isWSL(): boolean {
  try {
    // Check if /proc/version exists and contains Microsoft or WSL
    if (fs.existsSync('/proc/version')) {
      const procVersion = fs.readFileSync('/proc/version', 'utf-8');
      return procVersion.toLowerCase().includes('microsoft') || procVersion.toLowerCase().includes('wsl');
    }
    // Check for WSL-specific directory
    return fs.existsSync('/mnt/c');
  } catch {
    return false;
  }
}

// Play WAV file based on platform
function playWavFile(wavPath: string): void {
  // Check if WAV file exists
  if (!fs.existsSync(wavPath)) {
    console.error(`WAV file not found: ${wavPath}`);
    return;
  }
  
  const platform = process.platform;
  
  if (platform === 'darwin') {
    // macOS - use afplay
    const afplay = spawn('afplay', [wavPath], {
      detached: true,
      stdio: 'ignore'
    });
    afplay.unref();
    
  } else if (platform === 'win32' || isWSL()) {
    // Windows or WSL - use PowerShell SoundPlayer
    const command = isWSL() ? 'powershell.exe' : 'powershell';
    
    // Escape the path for PowerShell
    const escapedPath = wavPath.replace(/'/g, "''");
    
    const ps = spawn(command, [
      '-NoProfile',
      '-NonInteractive',
      '-Command',
      `(New-Object Media.SoundPlayer '${escapedPath}').PlaySync()`
    ], {
      detached: true,
      stdio: 'ignore',
      windowsHide: true
    });
    ps.unref();
    
  } else if (platform === 'linux' && !isWSL()) {
    // Native Linux - try paplay first, then aplay
    const paplay = spawn('paplay', [wavPath], {
      detached: true,
      stdio: 'ignore'
    });
    
    paplay.on('error', () => {
      // If paplay fails, try aplay
      const aplay = spawn('aplay', [wavPath], {
        detached: true,
        stdio: 'ignore'
      });
      
      aplay.on('error', (err) => {
        console.error('Failed to play sound with both paplay and aplay:', err.message);
      });
      
      aplay.unref();
    });
    
    paplay.unref();
    
  } else {
    // Unsupported platform
    console.error(`Sound notifications not supported on platform: ${platform}`);
  }
}

async function main() {
  try {
    // Read input from stdin
    const input = await readStdin();
    
    // Don't run if already in a stop hook loop
    if (input.stop_hook_active === true) {
      process.exit(0);
    }
    
    // Get the hook type
    const hookType = input.hook_event_name || 'Unknown';
    
    // Load configuration
    const config = loadEnvConfig();
    
    // Determine which WAV file to play
    const wavFileName = getWavForHook(hookType, config, input);
    
    if (wavFileName) {
      // Get WAV file path and play it
      const wavPath = getWavFilePath(wavFileName);
      playWavFile(wavPath);
    }
    
    // For PreToolUse hooks, we need to pass through the original response
    if (hookType === 'PreToolUse' && process.stdout.isTTY === false) {
      // Pass through any decision from previous hooks
      if ('decision' in input) {
        process.stdout.write(JSON.stringify({ 
          decision: input.decision,
          reason: input.reason 
        }));
      } else {
        // Return empty object to not interfere with other hooks
        process.stdout.write('{}');
      }
    }
    
    // Exit cleanly
    process.exit(0);
  } catch (error) {
    // Log error but don't interrupt Claude Code
    console.error('Sound hook error:', error);
    
    // For PreToolUse, still need to return valid JSON
    if (process.stdout.isTTY === false) {
      process.stdout.write('{}');
    }
    
    process.exit(0);
  }
}

// Run the hook
main().catch(() => {
  // Always exit cleanly
  if (process.stdout.isTTY === false) {
    process.stdout.write('{}');
  }
  process.exit(0);
});