'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "worker.js": "8857a5ab54124f196d3dc194c2b6fae7",
"assets/assets/images/title.svg": "11a67884ec5d1056b213062b78855526",
"assets/assets/images/explosion_3.svg": "bd4fe5df8c69b3cc991b8b71ac37b6f0",
"assets/assets/images/explosion_4.svg": "39e32bab996a293af0d977a1a4172bbd",
"assets/assets/images/stars.png": "0062e62c873427b4f01073dbf55801aa",
"assets/assets/images/meteo.png": "3d5b225c7abb3e7b7ee7ed296d91272b",
"assets/assets/images/explosion_5.svg": "a3db0feef62c1e8b0ae7b6bee7bbeaf1",
"assets/assets/images/explosion_2.svg": "0547ce6e0c32ae2ace584924ea9fbc0e",
"assets/assets/images/explosion_1.svg": "89e035d7468fd6bc9978cfefff485cb2",
"assets/assets/images/explosion_6.svg": "7f6cdcf2ba65e497d2f26081d433b071",
"assets/assets/images/rocket.svg": "97a349c8fd8559c2eb8e8e9f634979e0",
"assets/assets/images/commet.png": "00b506b45ffe3542284c642e4043064b",
"assets/assets/images/earth.png": "381c59054219ef7906601e39cbdebd89",
"assets/assets/fonts/Monoton-Regular.ttf": "d20753b0996b7092460eef623995f880",
"assets/assets/fonts/NunitoSans-Black.ttf": "cdfd114824e2a9c50aa097085f2e80a2",
"assets/FontManifest.json": "1d4d511a552d2e4415c67fe17c2dd32a",
"assets/AssetManifest.json": "66853031e3da05b97b692f7a453a697e",
"assets/NOTICES": "7cc6015b1d2daae774e6f3737b81e470",
"assets/fonts/MaterialIcons-Regular.otf": "7e7a6cccddf6d7b20012a548461d5d81",
"index.html": "1b2770e3a7c674eec3e726ad613e2d17",
"/": "1b2770e3a7c674eec3e726ad613e2d17",
"version.json": "0c7f51d2c5448539658a08946017444b",
"icons/Icon-maskable-192.png": "e0a4a651e8b085016a64328bd59f1b0f",
"icons/Icon-maskable-512.png": "0385f5657691fd524fa406fe1387e15a",
"icons/Icon-512.png": "0385f5657691fd524fa406fe1387e15a",
"icons/Icon-192.png": "e0a4a651e8b085016a64328bd59f1b0f",
"main.dart.js": "e7f8a20d6caa276fe0d492ba9e19c594",
"apis.js": "950d825622cf9da7d328f974be7cbb07",
"favicon.png": "a119494480f47b1683897d2ce191f0e9",
"manifest.json": "6fcdc304cc8add9f0d9d4cb10152e512",
"canvaskit/profiling/canvaskit.js": "ae2949af4efc61d28a4a80fffa1db900",
"canvaskit/profiling/canvaskit.wasm": "95e736ab31147d1b2c7b25f11d4c32cd",
"canvaskit/canvaskit.js": "c2b4e5f3d7a3d82aed024e7249a78487",
"canvaskit/canvaskit.wasm": "4b83d89d9fecbea8ca46f2f760c5a9ba"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
