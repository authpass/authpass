'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/assets/images/logo_icon.png": "35479aa0e7346455edd778b808b77493",
"assets/assets/images/safe-filled.webp": "164f125783ea068b36bdeb70f7e3a1cd",
"assets/assets/images/logo_with_text.png": "5eebe4e497f49e52a2e232701b4700af",
"assets/assets/images/authpass-logo-fit-512w.webp": "1be2a6113e3710ecc981f1f083004da0",
"assets/assets/images/safe-empty-v2.webp": "f6b70e9bf07eb46f169d5f7573fd263d",
"assets/assets/images/safe-empty.webp": "634514bcdcf32f8867539bc360861947",
"assets/assets/images/safe-filled-v2.webp": "b363d92ca6a9fb930a1b0085918dfe6b",
"assets/assets/images/onboarding-header.webp": "7d66953934b52bf1dca2c49c5a0b64cf",
"assets/assets/fonts/Inter-Medium.otf": "8c46da0df447785681cc1dc57c1a9da9",
"assets/assets/fonts/Inter-Light.otf": "a3a9cc1541c9da02424062b5855a60ec",
"assets/assets/fonts/Inter-Regular.otf": "9a9eeddb3eb9ce4f64e378a8a7b9c042",
"assets/assets/fonts/AuthPassIcons.ttf": "f4995281378f62ba2c270f086aa802de",
"assets/assets/fonts/jetbrains/JetBrainsMono-Bold.ttf": "d8af470e44be6c1d2d07dee84db355f6",
"assets/assets/fonts/jetbrains/JetBrainsMono-Regular.ttf": "e1caef645de334fee2f25834b0d03c28",
"assets/assets/fonts/Inter-Bold.otf": "753bd86618b0faefb54da21403a261bb",
"assets/FontManifest.json": "99d8ea2f0fa233677aa50559f5efa9a0",
"assets/AssetManifest.json": "05790f000289f3ecb4c5744ac6d9c7f1",
"assets/NOTICES": "4c660fb29feca49931472efb5febce7d",
"assets/AssetManifest.bin": "473241aeb484c80cce6940735916c7cd",
"assets/shaders/ink_sparkle.frag": "4096b5150bac93c41cbc9b45276bd90f",
"assets/AssetManifest.bin.json": "e735744388f9ef097043d935d3ee22bd",
"assets/fonts/MaterialIcons-Regular.otf": "bdd1332ff7d94c01e311c5203bff018f",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "7f7db30136ec7d61411d693155dd0574",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "12878cc0267ced6dfc49256c7232a61b",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "b698a8e676c5b0e37dc2360a5778c62f",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "f2163b9d4e6f1ea52063f498c8878bb9",
"manifest.json": "a55e3e721de6d5444c9dc74af6ebb2c1",
"index.html": "1a2477f3757f9480d372f2add8d62ed9",
"/": "1a2477f3757f9480d372f2add8d62ed9",
"js/README.md": "20e28da2a4aaa5b4956d794075e1d6a6",
"js/argon2-bundled.min.js": "6c006c4658c1954a2e78b68130f97ea7",
"canvaskit/chromium/canvaskit.wasm": "143af6ff368f9cd21c863bfa4274c406",
"canvaskit/chromium/canvaskit.js": "0ae8bbcc58155679458a0f7a00f66873",
"canvaskit/skwasm.wasm": "2fc47c0a0c3c7af8542b601634fe9674",
"canvaskit/skwasm.js": "87063acf45c5e1ab9565dcf06b0c18b8",
"canvaskit/canvaskit.wasm": "73584c1a3367e3eaf757647a8f5c5989",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/canvaskit.js": "eb8797020acdbdf96a12fb0405582c1b",
"icons/authpass-launcher-192.png": "66bc9dfe1b283d730ec395348dc97d31",
"icons/authpass-launcher-512.png": "b9ba6d8d7c5a550b37ed6937d5bea4de",
"favicon.ico": "5e9ecce5608cfbeda2db0b5e8be7fa7d",
"favicon.png": "0f6bc457452337dff399ad2f7da1786a",
"main.dart.js": "2a5f631ecda3bfa74428fa7f8a17c00e",
"flutter.js": "7d69e653079438abfbb24b82a655b0a4",
"version.json": "32ff7767ab1f612ce06d2832209a1c03"};
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
