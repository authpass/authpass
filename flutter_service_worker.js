'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/assets/fonts/Inter-Medium.otf": "8c46da0df447785681cc1dc57c1a9da9",
"assets/assets/fonts/Inter-Bold.otf": "753bd86618b0faefb54da21403a261bb",
"assets/assets/fonts/AuthPassIcons.ttf": "f4995281378f62ba2c270f086aa802de",
"assets/assets/fonts/jetbrains/JetBrainsMono-Regular.ttf": "e1caef645de334fee2f25834b0d03c28",
"assets/assets/fonts/jetbrains/JetBrainsMono-Bold.ttf": "d8af470e44be6c1d2d07dee84db355f6",
"assets/assets/fonts/Inter-Regular.otf": "9a9eeddb3eb9ce4f64e378a8a7b9c042",
"assets/assets/fonts/Inter-Light.otf": "a3a9cc1541c9da02424062b5855a60ec",
"assets/assets/images/safe-empty-v2.webp": "f6b70e9bf07eb46f169d5f7573fd263d",
"assets/assets/images/safe-empty.webp": "634514bcdcf32f8867539bc360861947",
"assets/assets/images/onboarding-header.webp": "7d66953934b52bf1dca2c49c5a0b64cf",
"assets/assets/images/logo_icon.png": "35479aa0e7346455edd778b808b77493",
"assets/assets/images/logo_with_text.png": "5eebe4e497f49e52a2e232701b4700af",
"assets/assets/images/authpass-logo-fit-512w.webp": "1be2a6113e3710ecc981f1f083004da0",
"assets/assets/images/safe-filled-v2.webp": "b363d92ca6a9fb930a1b0085918dfe6b",
"assets/assets/images/safe-filled.webp": "164f125783ea068b36bdeb70f7e3a1cd",
"assets/fonts/MaterialIcons-Regular.otf": "2e7f7c7a9b1cf0917cd607f2c2683a00",
"assets/AssetManifest.json": "05790f000289f3ecb4c5744ac6d9c7f1",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "5070443340d1d8cceb516d02c3d6dee7",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "d7791ef376c159f302b8ad90a748d2ab",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "658b490c9da97710b01bd0f8825fce94",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "f2163b9d4e6f1ea52063f498c8878bb9",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"assets/AssetManifest.bin": "473241aeb484c80cce6940735916c7cd",
"assets/FontManifest.json": "99d8ea2f0fa233677aa50559f5efa9a0",
"assets/NOTICES": "1c281ae9c02d5ead684e98617303619a",
"version.json": "96d01517297f39743ade6090c6d43266",
"js/README.md": "20e28da2a4aaa5b4956d794075e1d6a6",
"js/argon2-bundled.min.js": "6c006c4658c1954a2e78b68130f97ea7",
"favicon.ico": "5e9ecce5608cfbeda2db0b5e8be7fa7d",
"manifest.json": "a55e3e721de6d5444c9dc74af6ebb2c1",
"index.html": "f6dbdb188baed6e512df84e1270c2701",
"/": "f6dbdb188baed6e512df84e1270c2701",
"favicon.png": "0f6bc457452337dff399ad2f7da1786a",
"flutter.js": "6fef97aeca90b426343ba6c5c9dc5d4a",
"icons/authpass-launcher-192.png": "66bc9dfe1b283d730ec395348dc97d31",
"icons/authpass-launcher-512.png": "b9ba6d8d7c5a550b37ed6937d5bea4de",
"main.dart.js": "4cdcd1b6949723af183658e34d49da37",
"canvaskit/canvaskit.wasm": "d9f69e0f428f695dc3d66b3a83a4aa8e",
"canvaskit/skwasm.wasm": "d1fde2560be92c0b07ad9cf9acb10d05",
"canvaskit/canvaskit.js": "5caccb235fad20e9b72ea6da5a0094e6",
"canvaskit/skwasm.worker.js": "51253d3321b11ddb8d73fa8aa87d3b15",
"canvaskit/chromium/canvaskit.wasm": "393ec8fb05d94036734f8104fa550a67",
"canvaskit/chromium/canvaskit.js": "ffb2bb6484d5689d91f393b60664d530",
"canvaskit/skwasm.js": "95f16c6690f955a45b2317496983dbe9"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
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
        // Claim client to enable caching on first launch
        self.clients.claim();
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
      // Claim client to enable caching on first launch
      self.clients.claim();
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
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
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
