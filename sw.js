// AI疤痕面诊 - Service Worker v2.0
const CACHE = 'ai-scar-v2';
const STATIC_FILES = [
  '/',
  '/index.html',
  '/manifest.json',
  '/icons/icon-192.png',
  '/icons/icon-512.png'
];

// 安装：缓存静态资源
self.addEventListener('install', function(e) {
  e.waitUntil(
    caches.open(CACHE).then(function(cache) {
      return cache.addAll(STATIC_FILES);
    }).then(function() {
      return self.skipWaiting();
    })
  );
});

// 激活：清理旧缓存
self.addEventListener('activate', function(e) {
  e.waitUntil(
    caches.keys().then(function(keys) {
      return Promise.all(
        keys.filter(function(k) { return k !== CACHE; })
          .map(function(k) { return caches.delete(k); })
      );
    }).then(function() {
      return self.clients.claim();
    })
  );
});

// 拦截请求：缓存优先，网络回退
self.addEventListener('fetch', function(e) {
  var url = new URL(e.request.url);

  // API 请求不缓存
  if (url.pathname.startsWith('/api/')) return;

  e.respondWith(
    caches.match(e.request).then(function(r) {
      return r || fetch(e.request).then(function(res) {
        // 只缓存静态资源
        if (res.ok && url.origin === self.location.origin &&
            !url.pathname.startsWith('/api/')) {
          var clone = res.clone();
          caches.open(CACHE).then(function(cache) { cache.put(e.request, clone); });
        }
        return res;
      }).catch(function() {
        // 离线降级
        return caches.match('/index.html');
      });
    })
  );
});
