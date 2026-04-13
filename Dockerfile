FROM node:18-alpine

WORKDIR /app

# Install Python for simple HTTP server (fallback)
RUN apk add --no-cache python3

# Copy app files
COPY . .

# Expose port
EXPOSE 3000 8080

# Default command - starts static server
CMD ["node", "-e", "require('http').createServer((req, res) => { const fs = require('fs'); const path = require('path'); let filePath = '.' + req.url; if (filePath === './') filePath = './index.html'; const extname = path.extname(filePath); const mimeTypes = {'.html': 'text/html', '.js': 'application/javascript', '.css': 'text/css', '.json': 'application/json', '.png': 'image/png', '.jpg': 'image/jpg', '.gif': 'image/gif', '.svg': 'image/svg+xml'}; const contentType = mimeTypes[extname] || 'application/octet-stream'; fs.readFile(filePath, (err, content) => { if (err) { res.writeHead(404); res.end('Not Found'); } else { res.writeHead(200, {'Content-Type': contentType, 'Cache-Control': 'max-age=3600'}); res.end(content); } }); }).listen(3000, () => console.log('Server running on http://localhost:3000'));"]
