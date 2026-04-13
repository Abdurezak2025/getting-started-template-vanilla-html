# Sena FarmERP v7.0 - Quick Start Guide

## 🚀 Getting Started in 60 Seconds

### Windows Users
1. Open Command Prompt
2. Navigate to project folder: `cd C:\SenaFarmERP`
3. Run: `launch.bat`
4. Choose option 1 (Python server)
5. Browser opens automatically at `http://localhost:8080`

### macOS/Linux Users
1. Open Terminal
2. Navigate to project: `cd /path/to/SenaFarmERP`
3. Run: `bash launch.sh`
4. Choose option 1 (Python server)
5. Open browser at `http://localhost:8080`

---

## 📱 Platform-Specific Instructions

### Running Locally

#### Method 1: Python (All Platforms)
```bash
# Navigate to project folder
cd your-project-path

# Start server
python3 -m http.server 8080

# Open browser to: http://localhost:8080
```

#### Method 2: Node.js
```bash
node -e "const http = require('http'); const fs = require('fs'); http.createServer((req, res) => { let file = '.' + (req.url === '/' ? '/index.html' : req.url); fs.readFile(file, (err, data) => { res.writeHead(err ? 404 : 200); res.end(data || 'Not Found'); }); }).listen(3000); console.log('Server at http://localhost:3000');"
```

#### Method 3: Docker
```bash
docker build -t sena-farmerp:v7 .
docker run -p 3000:3000 sena-farmerp:v7
# Access at http://localhost:3000
```

### Desktop Installation

#### Chrome/Edge
1. Visit `http://localhost:8080`
2. Click the **Install** button in the header
3. Confirm installation
4. App appears in Start menu and on desktop
5. Click to run like native app

#### Firefox
1. Visit `http://localhost:8080`
2. Click the **Install** button
3. App installs to desktop
4. Works offline automatically

#### Safari (macOS)
1. Visit `http://localhost:8080`
2. From Safari menu: **File > Add to Dock**
3. Or: **Share > Add to Home Screen** (iPad)
4. Opens in standalone window

### Mobile Installation

#### Android (Chrome)
1. Visit `http://localhost:8080` (or your domain)
2. Tap **Menu (⋮) > Install app**
3. Confirm
4. App appears on home screen
5. Works like native app

#### iPhone/iPad (Safari)
1. Visit `http://localhost:8080` (or your domain)
2. Tap **Share > Add to Home Screen**
3. Name: "Sena FarmERP"
4. Tap **Add**
5. App opens in standalone mode

### Offline Usage
- App automatically caches on first visit
- Works completely offline after initial load
- Local data syncs when connection returns
- Weather updates require internet

---

## 🌐 Domain Deployment

### Using Vercel (Fastest - Recommended)
```bash
# Install Vercel CLI
npm install -g vercel

# Deploy from project folder
vercel --prod

# Choose domain name when prompted
# Done! Your app is live with HTTPS
```

### Using Netlify
1. Go to [netlify.com](https://netlify.com)
2. Click "New site from Git" or drag & drop folder
3. Automatic deployment from Git pushes
4. Custom domain setup in **Site Settings**
5. Automatic HTTPS enabled

### Using GitHub Pages (Free)
1. Push project to GitHub
2. Go to repository **Settings > Pages**
3. Select **Deploy from branch: main**
4. App available at: `https://username.github.io/farmerp`

### Using Traditional Hosting (cPanel, Bluehost, etc.)
1. FTP into your hosting
2. Upload all files to `public_html/`
3. Set document root to project folder
4. Enable HTTPS/SSL
5. Access via your domain

---

## 📦 Production Build

```bash
# Create optimized production files
mkdir build
cp index.html main.css service.js manifest.webmanifest sw.js build/

# Minify for smaller file size (optional)
# Use online minifiers or build tools
```

Then upload `build/` folder to your hosting.

---

## 🔐 Security Checklist

Before launching publicly:

- [ ] Enable HTTPS on domain
- [ ] Update manifest.webmanifest with your domain
- [ ] Review and accept Terms of Service
- [ ] Review and accept Privacy Policy
- [ ] Test offline functionality
- [ ] Test on actual Android device
- [ ] Test on actual iOS device
- [ ] Check all languages work
- [ ] Verify service worker caching
- [ ] Test on slow 3G connection
- [ ] Set up analytics (optional)
- [ ] Configure error logging

---

## 📱 Play Store Submission (Android)

### Quick Version
```bash
# Install Bubblewrap
npm install -g @bubblewrap/cli

# Initialize TWA wrapper
bubblewrap init
# Fill in: app URL, package name, icon

# Build APK
bubblewrap build
# Generates: app-release.aab

# Upload to Play Console
# 1. Create developer account ($25)
# 2. Create new app
# 3. Upload AAB file
# 4. Fill metadata
# 5. Submit for review

# Monitor: Google Play Console dashboard
# Users auto-receive updates
```

### Detailed Version
See [PRODUCTION_DEPLOYMENT.md](./PRODUCTION_DEPLOYMENT.md) section 3

---

## 🆘 Troubleshooting

### App Won't Load
- **Check:** Is server running? (`http://localhost:8080` accessible?)
- **Fix:** Restart server, clear browser cache (Ctrl+Shift+Del)

### Service Worker Not Caching
- **Check:** Visit DevTools > Application > Service Workers
- **Fix:** Hard refresh (Ctrl+Shift+R), check browser console for errors

### Can't Install PWA
- **Check:** HTTPS enabled? (Not http://)
- **Fix:** Use production domain, not localhost. Update manifest.

### Weather Data Not Loading
- **Check:** Internet connection active
- **Fix:** App works offline, but weather needs internet
- **Fallback:** Demo weather data shows if API unavailable

### Play Store Rejection
- **Common Issues:**
  - Missing privacy policy (add URL to manifest)
  - App crashes on actual device (test thoroughly)
  - Doesn't meet content policies
  
- **Fix:**
  1. Address all rejection reasons
  2. Resubmit after 3 hours minimum
  3. Read Google Play policies fully

---

## 📊 Production Monitoring

After launch:

1. **Check crash reports** in Play Console daily
2. **Monitor analytics** (optional setup)
3. **Review user feedback** in store listings
4. **Update regularly** with bug fixes and features
5. **Maintain servers** and check uptime

---

## 💡 Next Steps

1. ✅ Get app running locally
2. ✅ Test thoroughly on your devices
3. ✅ Set up domain
4. ✅ Deploy to production
5. ✅ Build Android TWA wrapper
6. ✅ Submit to Play Store
7. ✅ Monitor and support users
8. ✅ Plan updates and improvements

---

## 📞 Support Resources

- **Documentation:** This repository's markdown files
- **Tutorials:** Search "PWA tutorial" or "Android TWA"
- **Platforms:** Vercel, Netlify, Google Cloud docs
- **Community:** Reddit r/webdev, r/androiddev

---

**Version:** 7.0.0  
**Last Updated:** April 13, 2026
