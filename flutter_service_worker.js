'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"assets/assets/images/logo_icon.png": "35479aa0e7346455edd778b808b77493",
"assets/assets/images/onboarding-header.webp": "7d66953934b52bf1dca2c49c5a0b64cf",
"assets/assets/images/safe-empty.webp": "634514bcdcf32f8867539bc360861947",
"assets/assets/images/safe-filled-v2.webp": "b363d92ca6a9fb930a1b0085918dfe6b",
"assets/assets/images/safe-empty-v2.webp": "f6b70e9bf07eb46f169d5f7573fd263d",
"assets/assets/images/safe-filled.webp": "164f125783ea068b36bdeb70f7e3a1cd",
"assets/assets/images/logo_with_text.png": "5eebe4e497f49e52a2e232701b4700af",
"assets/assets/images/authpass-logo-fit-512w.webp": "1be2a6113e3710ecc981f1f083004da0",
"assets/assets/fonts/Inter-Regular.otf": "9a9eeddb3eb9ce4f64e378a8a7b9c042",
"assets/assets/fonts/AuthPassIcons.ttf": "f4995281378f62ba2c270f086aa802de",
"assets/assets/fonts/Inter-Bold.otf": "753bd86618b0faefb54da21403a261bb",
"assets/assets/fonts/Inter-Medium.otf": "8c46da0df447785681cc1dc57c1a9da9",
"assets/assets/fonts/Inter-Light.otf": "a3a9cc1541c9da02424062b5855a60ec",
"assets/assets/fonts/jetbrains/JetBrainsMono-Regular.ttf": "e1caef645de334fee2f25834b0d03c28",
"assets/assets/fonts/jetbrains/JetBrainsMono-Bold.ttf": "d8af470e44be6c1d2d07dee84db355f6",
"assets/FontManifest.json": "20c3315d1dcb02fe93beb9346fa71359",
"assets/AssetManifest.bin": "e14bd86b3b8b986ecf590034accf8455",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/NOTICES": "82ce9dcd1fdbfaa0a66a8e15cf6c63a9",
"assets/AssetManifest.json": "968a31d10a0d2512b97952f3ca99b0ee",
"assets/packages/font_awesome_flutter/lib/fonts/Font%2520Awesome%25207%2520Free-Solid-900.otf": "8813f2c9829325a510df9e996d8f0883",
"assets/packages/font_awesome_flutter/lib/fonts/Font%2520Awesome%25207%2520Brands-Regular-400.otf": "e9649bfea1ba6a71d5952673cdc20c9e",
"assets/packages/font_awesome_flutter/lib/fonts/Font%2520Awesome%25207%2520Free-Regular-400.otf": "b02e19250f0a8ed8a2767a6dd9de13c0",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "d7d83bd9ee909f8a9b348f56ca7b68c6",
"assets/AssetManifest.bin.json": "5022a542bca98788f001bb9993415172",
"assets/fonts/MaterialIcons-Regular.otf": "c078bac6da3f215e8d8fe9be84290793",
"icons/authpass-launcher-512.png": "b9ba6d8d7c5a550b37ed6937d5bea4de",
"icons/authpass-launcher-192.png": "66bc9dfe1b283d730ec395348dc97d31",
"flutter_bootstrap.js": "3f353e02020e0d3d4bff4cb3cf8f9e10",
"js/README.md": "20e28da2a4aaa5b4956d794075e1d6a6",
"js/argon2-bundled.min.js": "6c006c4658c1954a2e78b68130f97ea7",
"version.json": "cc681d16835f6738625565aacefd6eb5",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"favicon.ico": "5e9ecce5608cfbeda2db0b5e8be7fa7d",
"index.html": "3c2e85600a7d4ca0151f2ad00a733e65",
"/": "3c2e85600a7d4ca0151f2ad00a733e65",
"favicon.png": "0f6bc457452337dff399ad2f7da1786a",
"main.dart.js": "2d0f6a2891f46aba87e4fb3968fc7ecc",
"manifest.json": "a55e3e721de6d5444c9dc74af6ebb2c1"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
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
