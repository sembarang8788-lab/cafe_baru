@echo off
title Cafe Cak Yusop Server
echo ========================================
echo   Cafe Cak Yusop - Production Server
echo ========================================
echo.
echo Building project...
cd /d d:\antygrafity\cafe_baru
call npm run build
echo.
echo Server berjalan di port 5173...
echo URL: http://localhost:5173/cafe_cakyusop/
echo Tekan Ctrl+C untuk menghentikan server.
echo.
serve -s dist -l 5173 -c serve.json
pause
