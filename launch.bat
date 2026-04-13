@echo off
REM Sena FarmERP v7.0 - Quick Launch Script for Windows
REM Run as Administrator for best results

color 0A
echo.
echo ╔════════════════════════════════════════════════════╗
echo ║     Sena FarmERP v7.0 - Quick Launch (Windows)    ║
echo ╚════════════════════════════════════════════════════╝
echo.

REM Check Python installation
python --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Python found
    set HAS_PYTHON=1
) else (
    echo ❌ Python not found. Download from https://python.org
    set HAS_PYTHON=0
)

REM Check Node.js installation
node --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Node.js found
    set HAS_NODE=1
) else (
    echo ⚠️ Node.js not found (optional)
    set HAS_NODE=0
)

echo.
echo Choose deployment option:
echo 1) Local Server (Python - Port 8080) [Recommended]
echo 2) Local Server (Node.js - Port 3000)
echo 3) Create Production Build
echo 4) Open in Default Browser (HTTP)
echo.

set /p choice="Enter choice (1-4): "

if "%choice%"=="1" (
    if %HAS_PYTHON% equ 1 (
        echo Starting Python HTTP Server on http://localhost:8080
        timeout /t 2
        start http://localhost:8080
        python -m http.server 8080
    ) else (
        echo Python not found. Please install Python first.
        pause
        exit /b 1
    )
) else if "%choice%"=="2" (
    if %HAS_NODE% equ 1 (
        echo Starting Node.js Server on http://localhost:3000
        timeout /t 2
        start http://localhost:3000
        node -e "const http = require('http'); const fs = require('fs'); const path = require('path'); http.createServer((req, res) => { let filePath = '.' + req.url; if (filePath === './') filePath = './index.html'; const extname = path.extname(filePath); const mimeTypes = {'.html': 'text/html', '.js': 'application/javascript', '.css': 'text/css', '.json': 'application/json', '.png': 'image/png', '.jpg': 'image/jpg', '.svg': 'image/svg+xml'}; const contentType = mimeTypes[extname] || 'text/plain'; fs.readFile(filePath, (err, content) => { if (err) { res.writeHead(404); res.end('Not Found'); } else { res.writeHead(200, {'Content-Type': contentType, 'Cache-Control': 'max-age=3600'}); res.end(content); } }); }).listen(3000, () => { console.log('Server running on http://localhost:3000'); console.log('Press Ctrl+C to stop'); });"
    ) else (
        echo Node.js not found. Please install from https://nodejs.org
        pause
        exit /b 1
    )
) else if "%choice%"=="3" (
    if not exist "build" mkdir build
    echo Copying files to build folder...
    copy index.html build\ >nul
    copy main.css build\ >nul
    copy service.js build\ >nul
    copy manifest.webmanifest build\ >nul
    copy sw.js build\ >nul
    echo ✅ Production build complete in .\build\
    echo.
    echo To deploy:
    echo 1. Upload 'build' folder contents to your hosting provider
    echo 2. Configure HTTPS on your domain
    echo 3. Update manifest.webmanifest with your domain URL
    pause
) else if "%choice%"=="4" (
    echo Opening index.html in default browser...
    start index.html
) else (
    echo ❌ Invalid choice
    pause
    exit /b 1
)
