# Cafe Cak Yusop - Stop Server
# Script untuk menghentikan server yang berjalan di background

$pidFile = "d:\antygrafity\cafe_baru\server.pid"

if (Test-Path $pidFile) {
    $pid = Get-Content $pidFile
    try {
        $proc = Get-Process -Id $pid -ErrorAction Stop
        Stop-Process -Id $pid -Force
        Remove-Item $pidFile -Force
        Write-Host "✅ Server (PID: $pid) berhasil dihentikan." -ForegroundColor Green
    } catch {
        Write-Host "⚠ Server dengan PID $pid sudah tidak berjalan." -ForegroundColor Yellow
        Remove-Item $pidFile -Force
    }
} else {
    Write-Host "⚠ File PID tidak ditemukan. Mencoba mencari proses serve..." -ForegroundColor Yellow
    $serveProcesses = Get-Process -Name "node" -ErrorAction SilentlyContinue | Where-Object {
        $_.CommandLine -like "*serve*"
    }
    if ($serveProcesses) {
        $serveProcesses | Stop-Process -Force
        Write-Host "✅ Proses serve berhasil dihentikan." -ForegroundColor Green
    } else {
        Write-Host "ℹ Tidak ada server yang sedang berjalan." -ForegroundColor Cyan
    }
}
