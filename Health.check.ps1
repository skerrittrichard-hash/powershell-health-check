# Server Health Check Script
# Author: Richard
# Purpose: Monitor disk space and memory on this machine

Write-Host "=== SERVER HEALTH CHECK ===" -ForegroundColor Green
Write-Host ""

# Check Disk Space (C: drive)
$disk = Get-Volume -DriveLetter C
$diskFree = [math]::Round($disk.SizeRemaining / 1GB, 2)
$diskTotal = [math]::Round($disk.Size / 1GB, 2)
$diskPercent = [math]::Round(($disk.SizeRemaining / $disk.Size) * 100, 2)

Write-Host "DISK SPACE (C: Drive):"
Write-Host "  Free: $diskFree GB / $diskTotal GB"
Write-Host "  Available: $diskPercent%"
Write-Host ""

# Alert if low disk space
if ($diskPercent -lt 20) {
    Write-Host "  WARNING: Low disk space!" -ForegroundColor Red
}

# Check Memory
$memory = Get-CimInstance -ClassName CIM_OperatingSystem
$memUsed = [math]::Round(($memory.TotalVisibleMemorySize - $memory.FreePhysicalMemory) / 1MB, 2)
$memTotal = [math]::Round($memory.TotalVisibleMemorySize / 1MB, 2)
$memPercent = [math]::Round((($memory.TotalVisibleMemorySize - $memory.FreePhysicalMemory) / $memory.TotalVisibleMemorySize) * 100, 2)

Write-Host "MEMORY:"
Write-Host "  Used: $memUsed MB / $memTotal MB"
Write-Host "  Usage: $memPercent%"
Write-Host ""

# Alert if high memory usage
if ($memPercent -gt 80) {
    Write-Host "  WARNING: High memory usage!" -ForegroundColor Red
}

# Check CPU Usage (last 5 seconds)
$cpuUsage = (Get-CimInstance win32_processor).LoadPercentage

Write-Host "CPU USAGE:"
Write-Host "  Current: $cpuUsage%"
Write-Host ""

if ($cpuUsage -gt 80) {
    Write-Host "  WARNING: High CPU usage!" -ForegroundColor Red
}

Write-Host "=== CHECK COMPLETE ===" -ForegroundColor Green