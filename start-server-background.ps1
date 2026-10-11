# Cafe Cak Yusop - Background Server Launcher
# Script ini menjalankan server sebagai background process yang TIDAK mati ketika terminal ditutup

$serverPath = 'd:\antygrafity\cafe_baru\dist'
$port = 5173
$logFile = 'd:\antygrafity\cafe_baru\server.log'
$pidFile = 'd:\antygrafity\cafe_baru\server.pid'

# Cek apakah port sudah digunakan
$portInUse = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
if ($portInUse) {
    Write-Host "Port $port sudah digunakan! Menghentikan proses lama..." -ForegroundColor Yellow
    $portInUse | ForEach-Object {
        Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue
    }
    Start-Sleep -Seconds 2
}

# Cek apakah serve sudah terinstall
$servePath = (Get-Command serve -ErrorAction SilentlyContinue).Source
if (-not $servePath) {
    Write-Host "'serve' belum terinstall. Jalankan: npm install -g serve" -ForegroundColor Red
    exit 1
}

# Build project terlebih dahulu
Write-Host "Building project..." -ForegroundColor Yellow
Set-Location 'd:\antygrafity\cafe_baru'
npm run build
if ($LASTEXITCODE -ne 0) {
    Write-Host "Build gagal! Periksa error di atas." -ForegroundColor Red
    exit 1
}
Write-Host "Build selesai!" -ForegroundColor Green

# Buat argument string - serve di port 5173 dengan base path /cafe_cakyusop/
$cmdArgs = '/c serve -s "' + $serverPath + '" -l ' + $port + ' -c "d:\antygrafity\cafe_baru\serve.json" > "' + $logFile + '" 2>&1'

# Jalankan sebagai hidden background process
$process = Start-Process -FilePath "cmd.exe" -ArgumentList $cmdArgs -WindowStyle Hidden -PassThru

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Cafe Cak Yusop Server Started!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$localUrl = "http://localhost:" + $port + "/cafe_cakyusop/"
$networkUrl = "http://192.168.1.100:" + $port + "/cafe_cakyusop/"
$pid_val = $process.Id

Write-Host "  Local:    $localUrl" -ForegroundColor White
Write-Host "  Network:  $networkUrl" -ForegroundColor White
Write-Host "  Dir:      $serverPath" -ForegroundColor White
Write-Host "  Log:      $logFile" -ForegroundColor White
Write-Host "  PID:      $pid_val" -ForegroundColor White
Write-Host ""
Write-Host "  Server berjalan di BACKGROUND." -ForegroundColor Yellow
Write-Host "  Terminal bisa ditutup, server TETAP jalan!" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Untuk menghentikan server:" -ForegroundColor Gray

$stopCmd = "Stop-Process -Id " + $pid_val + " -Force"
Write-Host "  $stopCmd" -ForegroundColor Gray
Write-Host "  atau jalankan: .\stop-server.ps1" -ForegroundColor Gray
Write-Host ""

# Simpan PID ke file untuk referensi
$pid_val | Out-File -FilePath $pidFile -Force
