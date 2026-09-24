# auto_server_connect_rust

A PowerShell automation script for Rust that monitors a server around wipe time, launches the game client in advance, and connects automatically as soon as the server is back online.

## Features

- **Port Monitoring**: Continuously checks server status via TCP socket connection to query/game ports.
- **Failsafe Hour Check**: Prevents false triggers from random midday crashes or restarts before scheduled wipe times.
- **Automatic Game Launch**: Detects if Rust (`RustClient.exe`) is already open; if not, launches Rust via Steam ahead of time.
- **Auto-Connect**: Once the server completes wiping and comes back online, waits for stability and connects immediately using Steam's connect protocol.

## Configuration

Edit the variables at the top of `rust_wipe.ps1`:

```powershell
$IP = "168.100.161.157"      # Server IP address
$QueryPort = 28015           # Server Query Port
$GamePort = 28010            # Server Game Port
$EarliestWipeHour = 14       # Earliest hour (24-hour format) the wipe is expected
```

## Usage

Run the script in PowerShell:

```powershell
.\rust_wipe.ps1
```

> **Note**: Ensure your PowerShell execution policy allows running local scripts (e.g. `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass`).
