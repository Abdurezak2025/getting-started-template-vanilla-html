const CACHE_NAME = 'sena-farmerp-v7-cache-v1';
const ASSETS = [
  './',
  'index.html',
  'main.css',
  'service.js',
  'manifest.webmanifest',
  'sw.js'
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => cache.addAll(ASSETS))
  );
  self.skipWaiting();
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys => Promise.all(
      keys.filter(key => key !== CACHE_NAME).map(key => caches.delete(key))
    ))
  );
  self.clients.claim();
});

self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request).then(response => response || fetch(event.request).catch(() => {
      if (event.request.mode === 'navigate') return caches.match('index.html');
    }))
  );
});
