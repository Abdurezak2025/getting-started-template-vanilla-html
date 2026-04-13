#!/bin/bash

# Sena FarmERP v7.0 - Quick Launch Script
# Works on macOS, Linux, and Windows (with Git Bash)

set -e

echo "╔════════════════════════════════════════════════════╗"
echo "║     Sena FarmERP v7.0 - Quick Launch Script       ║"
echo "╚════════════════════════════════════════════════════╝"
echo ""

# Check Node.js installation
if command -v node &> /dev/null; then
    echo "✅ Node.js found: $(node --version)"
else
    echo "❌ Node.js not found. Install from https://nodejs.org"
    exit 1
fi

# Check Python installation
if command -v python3 &> /dev/null; then
    echo "✅ Python3 found: $(python3 --version)"
else
    echo "⚠️  Python3 not found (optional). Install from https://python.org"
fi

echo ""
echo "Choose deployment option:"
echo "1) Local Server (Python HTTP Server - Port 8080)"
echo "2) Local Server (Node.js - Port 3000)"
echo "3) Docker Container"
echo "4) Build for Production"
echo ""
read -p "Enter choice (1-4): " choice

case $choice in
    1)
        echo "Starting Python HTTP Server on http://localhost:8080"
        python3 -m http.server 8080
        ;;
    2)
        echo "Starting Node.js server on http://localhost:3000"
        node -e "
        const http = require('http');
        const fs = require('fs');
        const path = require('path');
        
        http.createServer((req, res) => {
            let filePath = '.' + req.url;
            if (filePath === './') filePath = './index.html';
            
            const extname = path.extname(filePath);
            const mimeTypes = {
                '.html': 'text/html',
                '.js': 'application/javascript',
                '.css': 'text/css',
                '.json': 'application/json',
                '.png': 'image/png',
                '.jpg': 'image/jpg',
                '.svg': 'image/svg+xml'
            };
            
            const contentType = mimeTypes[extname] || 'text/plain';
            
            fs.readFile(filePath, (err, content) => {
                if (err) {
                    res.writeHead(404);
                    res.end('Not Found');
                } else {
                    res.writeHead(200, {
                        'Content-Type': contentType,
                        'Cache-Control': 'max-age=3600'
                    });
                    res.end(content);
                }
            });
        }).listen(3000, () => {
            console.log('Server running on http://localhost:3000');
            console.log('Press Ctrl+C to stop');
        });
        "
        ;;
    3)
        if command -v docker &> /dev/null; then
            echo "Building Docker image..."
            docker build -t sena-farmerp:v7 .
            echo "Starting Docker container..."
            docker run -p 3000:3000 -p 8080:8080 --name sena-farmerp-v7 sena-farmerp:v7
        else
            echo "❌ Docker not found. Install from https://docker.com"
            exit 1
        fi
        ;;
    4)
        echo "Building for production..."
        mkdir -p build
        cp -r index.html main.css service.js manifest.webmanifest sw.js build/
        echo "✅ Production build complete in ./build/"
        echo ""
        echo "To deploy:"
        echo "1. Upload 'build' folder contents to your hosting provider"
        echo "2. Configure HTTPS on your domain"
        echo "3. Update manifest.webmanifest with your domain URL"
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac
