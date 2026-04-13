# Sena FarmERP v7.0

This repository contains the commercial Sena FarmERP v7.0 Enterprise AI Agribusiness web application owned and copyrighted by **Sena Agribusiness Investment Group PLC**.

## What this app includes

- PWA install support for Chrome/Edge and compatible browsers
- Offline-ready service worker caching
- Live weather integration using Open-Meteo
- Contract farming, agri-input procurement, finance ledger, GIS mapping, AI diagnostics dashboard
- Multilingual support including English, Amharic, German, and Afan Oromo

## Run locally

1. Open a terminal in the project folder.
2. Run a simple static server:

```bash
python3 -m http.server 8080
```

3. Open the app in your browser:

```text
http://localhost:8080
```

4. Use the `Install` button in the app header to add Sena FarmERP to your desktop or mobile device.

## Local app launch note

For best PWA behavior, serve the app from a local web server instead of opening `index.html` directly.

## How to deploy commercially

- Host the contents on a real domain or CDN
- Ensure HTTPS is enabled for PWA install and secure API usage
- Submit a Trusted Web Activity (TWA) wrapper to Google Play for Android publishing
- Use standard app store review and publishing pipelines for commercial launch

## Important

This app is already configured to run in production-like mode using free open data sources and PWA install support.

To connect to a backend or real enterprise data center, add your secure backend APIs in the `SenaERP` methods and replace demo data with live service endpoints.
