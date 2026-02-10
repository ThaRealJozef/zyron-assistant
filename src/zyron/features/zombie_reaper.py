"""
Zombie Process Reaper Module
Tracks process activity and identifies "zombies" - high memory usage apps that haven't been used (foreground) for a long time.
"""

import time
import psutil
import threading
import json
import os
from datetime import datetime
try:
    import win32gui
    import win32process
    HAS_WIN32 = True
except ImportError:
    HAS_WIN32 = False

# Configuration
CHECK_INTERVAL_SECONDS = 5   # Check every 5 seconds for testing
RAM_THRESHOLD_MB = 500       # Keep 500 MB (manual test allocates 600)
IDLE_THRESHOLD_SECONDS = 10  # 10 seconds for testing

# State
last_active_timestamps = {}  # {proc_name: timestamp}
zombie_candidates = {}       # {pid: {'name': str, 'ram': float, 'since': float}}
whitelist = []
reaper_active = False
reaper_thread = None

WHITELIST_FILE = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "utils", "zombie_whitelist.json")

def load_whitelist():
    global whitelist
    if os.path.exists(WHITELIST_FILE):
        try:
            with open(WHITELIST_FILE, 'r') as f:
                whitelist = json.load(f)
        except Exception as e:
            print(f"⚠️ Failed to load zombie whitelist: {e}")
            whitelist = []
    else:
        whitelist = []

def save_whitelist():
    try:
        os.makedirs(os.path.dirname(WHITELIST_FILE), exist_ok=True)
        with open(WHITELIST_FILE, 'w') as f:
            json.dump(whitelist, f, indent=2)
    except Exception as e:
        print(f"⚠️ Failed to save zombie whitelist: {e}")

def get_foreground_process_name():
    """Returns the name of the process owning the current foreground window."""
    if not HAS_WIN32: return None
    try:
        hwnd = win32gui.GetForegroundWindow()
        if not hwnd: return None
        _, pid = win32process.GetWindowThreadProcessId(hwnd)
        try:
            proc = psutil.Process(pid)
            return proc.name()
        except (psutil.NoSuchProcess, psutil.AccessDenied):
            return None
    except Exception:
        return None

def track_foreground_window():
    """Updates the last_active timestamp for the current foreground app."""
    current_app = get_foreground_process_name()
    if current_app:
        last_active_timestamps[current_app.lower()] = time.time()

def kill_process(pid):
    """Terminates a process by PID."""
    try:
        proc = psutil.Process(pid)
        name = proc.name()
        proc.terminate()
        return f"✅ Terminated {name} (PID: {pid})."
    except Exception as e:
        return f"❌ Failed to terminate PID {pid}: {e}"

def add_to_whitelist(app_name):
    """Adds an app name to the whitelist."""
    if app_name.lower() not in [x.lower() for x in whitelist]:
        whitelist.append(app_name)
        save_whitelist()
        return f"🛡️ Added {app_name} to whitelist."
    return f"ℹ️ {app_name} is already whitelisted."

def get_zombies():
    """
    Scans for zombie processes.
    Returns a list of dicts: {'pid', 'name', 'ram_mb', 'idle_time_str'}
    """
    zombies = []
    current_time = time.time()
    
    # 1. Update activity for current app first
    track_foreground_window()
    
    # 2. Scan all processes
    for proc in psutil.process_iter(['pid', 'name', 'memory_info']):
        try:
            pinfo = proc.info
            name = pinfo['name']
            pid = pinfo['pid']
            mem_mb = pinfo['memory_info'].rss / (1024 * 1024)
            
            # Skip whitelisted or system apps (basic filter)
            if name.lower() in [x.lower() for x in whitelist]:
                continue
            
            # Skip critical system processes (simple hardcoded list for safety)
            if name.lower() in ['explorer.exe', 'start_zyron.bat', 'python.exe', 'cmd.exe', 'svchost.exe', 'system', 'registry', 'smss.exe', 'csrss.exe', 'wininit.exe', 'services.exe', 'lsass.exe']:
                continue

            # Check Thresholds
            if mem_mb > RAM_THRESHOLD_MB:
                # Check idle time
                last_active = last_active_timestamps.get(name.lower(), current_time) # Default to now if never seen (conservative)
                idle_seconds = current_time - last_active
                
                # If we haven't seen it active and we've been running longer than IDLE_THRESHOLD? 
                # Actually, 'last_active_timestamps' only populates as we run. 
                # So if we just started, everything looks like "active just now" because we defaulted to current_time.
                # This is safe. It means we only kill things that go idle WHILE Zyron is running.
                
                if idle_seconds > IDLE_THRESHOLD_SECONDS:
                    # Found a zombie!
                    hours = int(idle_seconds // 3600)
                    minutes = int((idle_seconds % 3600) // 60)
                    
                    zombies.append({
                        'pid': pid,
                        'name': name,
                        'ram_mb': round(mem_mb, 1),
                        'idle_time_str': f"{hours}h {minutes}m"
                    })
        except (psutil.NoSuchProcess, psutil.AccessDenied):
            continue
            
    return zombies

def reaper_loop(callback_func):
    """Background thread loop."""
    global reaper_active
    print("🧟 Zombie Reaper: Active and hunting...")
    load_whitelist()
    
    # INITIALIZATION: Mark all current processes as "active now"
    # This ensures that background processes start "aging" from this moment.
    print(f"   [Debug] Initializing process timers...")
    start_time = time.time()
    for proc in psutil.process_iter(['name']):
        try:
            name = proc.info['name']
            if name:
                last_active_timestamps[name.lower()] = start_time
        except: pass
    print(f"   [Debug] Tracking {len(last_active_timestamps)} processes.")
    
    while reaper_active:
        track_foreground_window() # Track frequently
        
        # Check for zombies periodically (every check_interval)
        # We run the check logic every loop but fast-fail? 
        # No, let's just sleep short intervals and count ticks or just check time?
        # Better: Separate tracking from scanning.
        # For simplicity in this V1: Track every 5s, Scan every 60s.
        
        # We'll just sleep 10s here, track, and scan. 
        # Real idle threshold is hours, so 10s granularity is fine.
        
        # DEBUG: Print current check
        # print(f"   [Debug] Scanning... (Threshold: {RAM_THRESHOLD_MB}MB, {IDLE_THRESHOLD_SECONDS}s)")
        
        zombies = get_zombies()
        if zombies:
            print(f"   🧟 ZOMBIES FOUND: {[z['name'] for z in zombies]}")
            # Notify via callback (Telegram)
            if callback_func:
                callback_func(zombies)
        
        time.sleep(10) 

def start_reaper(callback_func=None):
    global reaper_active, reaper_thread
    if not HAS_WIN32:
        print("⚠️ Zombie Reaper requires pywin32. Disabled.")
        return

    if reaper_active: return
    
    reaper_active = True
    reaper_thread = threading.Thread(target=reaper_loop, args=(callback_func,), daemon=True)
    reaper_thread.start()

def stop_reaper():
    global reaper_active
    reaper_active = False

if __name__ == "__main__":
    # Test stub
    print("Testing Zombie Reaper...")
    HAS_WIN32 = True # Assume true for test
    start_reaper(lambda z: print(f"Caught zombies: {z}"))
    try:
        while True: time.sleep(1)
    except KeyboardInterrupt:
        stop_reaper()
