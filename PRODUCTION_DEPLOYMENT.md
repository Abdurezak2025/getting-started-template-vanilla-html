# Sena FarmERP v7.0 - Production Deployment Guide

## Overview

This guide provides step-by-step instructions to deploy Sena FarmERP v7.0 as a fully commercial, production-ready application across multiple platforms: web (domain), PWA (desktop/mobile), Google Play Store (Android), and local PC environments.

---

## 1. LOCAL PC DEPLOYMENT (C: Drive on Windows)

### Windows Setup
1. Copy the project to `C:\SenaFarmERP\` folder
2. Open Command Prompt as Administrator
3. Navigate to the folder:
```cmd
cd C:\SenaFarmERP
```
4. Start the local server:
```cmd
python -m http.server 8080
```
5. Open browser: `http://localhost:8080`

### macOS/Linux Setup
1. Copy project to desired location
2. Open Terminal
3. Navigate to project:
```bash
cd /path/to/SenaFarmERP
chmod +x run-local-server.sh
./run-local-server.sh
```
4. Open browser: `http://localhost:8080`

---

## 2. WEB DOMAIN DEPLOYMENT (Commercial Production)

### Prerequisites
- Domain name (e.g., `senafarm.app`, `farmerp.com`)
- Hosting provider with HTTPS support (Vercel, Netlify, AWS, Heroku, etc.)
- SSL/TLS certificate (auto-provided by most platforms)

### Step 1: Choose Hosting Provider

#### Option A: Vercel (RECOMMENDED - Fastest)
```bash
# Install Vercel CLI
npm install -g vercel

# Deploy from project root
vercel --prod
```
- Automatic HTTPS, worldwide CDN, free tier available

#### Option B: Netlify
1. Go to netlify.com
2. Drag & drop your project folder
3. Automatic deployment on every commit/push
4. Custom domain setup in Site Settings

#### Option C: GitHub Pages (Free)
```bash
# Push code to GitHub
git add .
git commit -m "Production release v7.0"
git push origin main

# Enable Pages in repository settings
# Access at: https://yourusername.github.io/farmerp
```

#### Option D: Traditional Hosting (cPanel, Bluehost, GoDaddy)
1. Upload all files via FTP to `public_html/` folder
2. Configure domain DNS to point to hosting provider
3. Ensure HTTPS/SSL is enabled
4. App will run at your domain URL

### Step 2: Configure Production Domain

After hosting is active:

1. **Update manifest.webmanifest:**
   - Change all API URLs to your domain
   - Update app start_url to match domain

2. **Configure HTTPS:**
   - Verify SSL certificate is active
   - Force HTTPS redirection

3. **Test Production:**
   - Visit `https://yourdomain.com`
   - Check PWA install button works
   - Test offline functionality

---

## 3. GOOGLE PLAY STORE DEPLOYMENT (Android)

### Prerequisites
- Google Play Developer Account ($25 one-time)
- Android app signing certificate
- Minimum 2 screenshots, 1 feature image
- Privacy policy URL (required)

### Step 1: Create Trusted Web Activity (TWA) Wrapper

Use Google's TWA Builder or Android Studio:

```bash
# Install Node.js if needed
npm install -g @bubblewrap/cli

# Initialize TWA project
bubblewrap init

# Settings to provide:
# App URL: https://yourdomain.com
# Package Name: com.senafarm.erp
# App Name: Sena FarmERP
# Launcher Icon: (provide 512x512 PNG)
```

### Step 2: Build Signed APK

```bash
bubblewrap build
```

This generates: `app-release.aab` (Android App Bundle)

### Step 3: Upload to Google Play Console

1. Go to play.google.com/console
2. Create new app: "Sena FarmERP v7.0"
3. Fill app details:
   - Category: Business or Productivity
   - Content Rating: Complete questionnaire
   - Privacy Policy: Link to your privacy policy
4. Upload AAB file to Production track
5. Add 2-4 screenshots, feature image
6. Set pricing (Free recommended)
7. Submit for Review (24-48 hours approval)

### Step 4: Monitor and Update

- Monitor crash reports in Play Console
- Push updates via Play Console
- Users auto-receive updates

---

## 4. iOS APP STORE DEPLOYMENT (iPhone/iPad)

### Option A: PWA Web Wrapper (Recommended - Faster)
- Users can add app to home screen via Safari "Share > Add to Home Screen"
- No App Store submission needed
- Works like native app

### Option B: Native Wrapper (Advanced)
- Use Capacitor or Flutter webview wrapper
- Submit to Apple App Store ($99/year developer account)
- More complex, but full native integration

---

## 5. SECURITY & PERFORMANCE CHECKLIST

Before production launch, verify:

- [ ] HTTPS enabled on domain
- [ ] Service Worker properly caching assets
- [ ] Environment variables for API keys secured
- [ ] Manifest.webmanifest matches domain
- [ ] Meta tags for SEO and sharing configured
- [ ] Lighthouse score > 90
- [ ] offline functionality tested
- [ ] All languages (English, Amharic, German, Oromo) work
- [ ] Mobile responsiveness verified on 3+ devices
- [ ] API rate limiting configured
- [ ] CORS policies properly set

### Performance Optimization

```bash
# Build optimization (if using build tools):
- Minify CSS/JS
- Enable gzip compression
- Optimize images to WebP format
- Cache static assets for 30+ days
- Use CDN for faster global delivery
```

---

## 6. MAINTENANCE & MONITORING

### Weekly Tasks
- Check server logs
- Monitor app crash reports
- Review user feedback

### Monthly Tasks
- Update dependencies
- Review analytics
- Backup database/user data
- Update SSL certificates (if needed)

### Quarterly Tasks
- Security audits
- Performance optimization
- Feature releases

---

## 7. ENVIRONMENT-SPECIFIC CONFIGURATION

### Development
```
API_ENV=development
LOG_LEVEL=debug
CACHE_DURATION=300
```

### Staging
```
API_ENV=staging
LOG_LEVEL=info
CACHE_DURATION=600
```

### Production
```
API_ENV=production
LOG_LEVEL=warn
CACHE_DURATION=3600
USE_CDN=true
```

---

## Support & Troubleshooting

### Common Issues

**Issue: App not installable on Android**
- Ensure HTTPS is enabled
- Check manifest.webmanifest is valid
- Service Worker must be working
- Minimum app requirements: 192x192 icon

**Issue: Domain DNS not resolving**
- Wait 24-48 hours for DNS propagation
- Clear browser cache: Ctrl+Shift+Del or Cmd+Shift+Del
- Verify DNS records in domain registrar

**Issue: Play Store rejection**
- Ensure privacy policy is accessible and clear
- Declare all permissions needed
- Test on actual Android device before submit
- Follow Google Play policies strictly

---

## Next Steps

1. ✅ Choose hosting provider
2. ✅ Configure domain
3. ✅ Upload files
4. ✅ Enable HTTPS
5. ✅ Test thoroughly
6. ✅ Build Android TWA wrapper
7. ✅ Submit to Play Store
8. ✅ Monitor and update regularly

**For questions or support, refer to official documentation:**
- Vercel: https://vercel.com/docs
- Netlify: https://docs.netlify.com
- Google Play: https://developer.android.com/play
- Bubblewrap: https://github.com/GoogleChromeLabs/bubblewrap
