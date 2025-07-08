#!/usr/bin/env bun
// Universal sound player hook - Plays different sounds based on hook type (macOS)

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

// Default sounds for different events
const DEFAULT_SOUNDS = {
  Stop: 'Glass',
  Notification: 'Ping',
  PreToolUseBlock: 'Basso',
  Error: 'Sosumi',
  Default: 'Tink'
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

// Determine which sound to play based on hook type and configuration
function getSoundForHook(hookType: string, config: SoundConfig, input: HookInput): string | null {
  // Check if sound notifications are enabled
  const soundEnabled = config.SOUND_NOTIFICATIONS_ENABLED?.toLowerCase() !== 'false';
  if (!soundEnabled) {
    return null;
  }
  
  switch (hookType) {
    case 'Stop':
      // Use STOP_SOUND or fall back to COMPLETION_SOUND for backward compatibility
      return config.STOP_SOUND || config.COMPLETION_SOUND || DEFAULT_SOUNDS.Stop;
      
    case 'Notification':
      return config.NOTIFICATION_SOUND || DEFAULT_SOUNDS.Notification;
      
    case 'PreToolUse':
      // Only play sound if command was blocked
      const preToolInput = input as PreToolUseInput;
      if (wasCommandBlocked(preToolInput)) {
        return config.PRETOOLUSE_BLOCK_SOUND || DEFAULT_SOUNDS.PreToolUseBlock;
      }
      return null; // Don't play sound for allowed commands
      
    case 'PostToolUse':
      // Could check for errors in tool_response
      if (input.tool_error) {
        return config.ERROR_SOUND || DEFAULT_SOUNDS.Error;
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

// Play sound based on platform
function playSound(soundName: string): void {
  const platform = process.platform;
  
  if (platform === 'darwin') {
    // macOS - use afplay
    const soundPath = `/System/Library/Sounds/${soundName}.aiff`;
    
    if (!fs.existsSync(soundPath)) {
      console.error(`Sound file not found: ${soundPath}`);
      return;
    }
    
    const afplay = spawn('afplay', [soundPath], {
      detached: true,
      stdio: 'ignore'
    });
    afplay.unref();
    
  } else if (platform === 'win32' || isWSL()) {
    // Windows or WSL - use PowerShell to play a beep
    // Note: This is a simple beep, not the actual system sound
    const command = isWSL() ? 'powershell.exe' : 'powershell';
    
    // Map sound names to different beep patterns
    let frequency = 800;
    let duration = 200;
    
    switch (soundName) {
      case 'Glass':
      case 'Funk':
        frequency = 1000;
        duration = 300;
        break;
      case 'Basso':
        frequency = 400;
        duration = 500;
        break;
      case 'Ping':
      case 'Submarine':
        frequency = 1500;
        duration = 150;
        break;
      case 'Sosumi':
        frequency = 600;
        duration = 400;
        break;
    }
    
    const ps = spawn(command, [
      '-NoProfile',
      '-NonInteractive',
      '-Command',
      `[Console]::Beep(${frequency}, ${duration})`
    ], {
      detached: true,
      stdio: 'ignore',
      windowsHide: true
    });
    ps.unref();
    
  } else if (platform === 'linux' && !isWSL()) {
    // Native Linux - try paplay or speaker-test
    // First try paplay (PulseAudio)
    const paplay = spawn('paplay', ['/usr/share/sounds/freedesktop/stereo/complete.oga'], {
      detached: true,
      stdio: 'ignore'
    });
    
    paplay.on('error', () => {
      // If paplay fails, try speaker-test for a simple beep
      const speakerTest = spawn('speaker-test', ['-t', 'sine', '-f', '1000', '-l', '1'], {
        detached: true,
        stdio: 'ignore'
      });
      
      // Kill speaker-test after 200ms
      setTimeout(() => {
        try {
          speakerTest.kill();
        } catch {}
      }, 200);
      
      speakerTest.unref();
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
    
    // Determine which sound to play
    const soundName = getSoundForHook(hookType, config, input);
    
    if (soundName) {
      // Play the sound
      playSound(soundName);
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