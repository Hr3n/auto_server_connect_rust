$IP = "168.100.161.157"
$QueryPort = 28015
$GamePort = 28010

# --- FAILSAFE SETTINGS ---
# Set the earliest hour (24-hour format) the wipe is allowed to happen.
# Example: If wipe is in the afternoon around 4 PM, set this to 14 (2:00 PM).
# Any server crash before this hour will be ignored as a random restart!
$EarliestWipeHour = 14 
# -------------------------

Write-Host "[$((Get-Date).ToString())] Monitoring Stevious 2x Main. Waiting for wipe..." -ForegroundColor Cyan

# Phase 1: Wait for the server to go offline, but verify the time
while ($true) {
    $currentTime = Get-Date
    try {
        $socket = New-Object System.Net.Sockets.TcpClient
        $socket.Connect($IP, $QueryPort)
        $socket.Close()
    }
    catch {
        # The server went offline. Let's check our failsafe!
        if ($currentTime.Hour -ge $EarliestWipeHour) {
            Write-Host "[$($currentTime.ToString())] Server went offline and it's past the target hour! Wipe has begun." -ForegroundColor Magenta
            break
        }
        else {
            Write-Host "[$($currentTime.ToString())] Server went offline, but it's too early ($($currentTime.Hour):00). Ignoring random restart..." -ForegroundColor Yellow
            # Wait 5 minutes for it to come back up, then resume normal monitoring
            Start-Sleep -Seconds 300
        }
    }
    Start-Sleep -Seconds 15
}

# Phase 2: Check if Rust is already running. If not, launch it now!
$rustProcess = Get-Process -Name "RustClient" -ErrorAction SilentlyContinue
if ($null -eq $rustProcess) {
    Write-Host "Rust is not running. Launching Rust now so it can boot up..." -ForegroundColor Yellow
    Start-Process "steam://rungameid/252490"
}
else {
    Write-Host "Rust is already running in the background." -ForegroundColor Green
}

# Phase 3: Wait for the server to finish wiping and come back online
Write-Host "Waiting for the server to finish wiping and come back online..." -ForegroundColor Yellow
while ($true) {
    Start-Sleep -Seconds 10
    try {
        $socket = New-Object System.Net.Sockets.TcpClient
        $socket.Connect($IP, $QueryPort)
        $socket.Close()
        
        Write-Host "[$((Get-Date).ToString())] Server is back ONLINE! Waiting 30 seconds for server to stabilize..." -ForegroundColor Green
        Start-Sleep -Seconds 30
        
        Write-Host "Connecting to server..." -ForegroundColor Green
        Start-Process "steam://connect/$IP`:$GamePort"
        break
    }
    catch {
        Write-Host "." -NoNewline
    }
}