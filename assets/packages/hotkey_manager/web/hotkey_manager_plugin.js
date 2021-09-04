const knownVirtualKeyCodes = {
  keyA: 0x41,
  keyB: 0x42,
  keyC: 0x43,
  keyD: 0x44,
  keyE: 0x45,
  keyF: 0x46,
  keyG: 0x47,
  keyH: 0x48,
  keyI: 0x49,
  keyJ: 0x4a,
  keyK: 0x4b,
  keyL: 0x4c,
  keyM: 0x4d,
  keyN: 0x4e,
  keyO: 0x4f,
  keyP: 0x50,
  keyQ: 0x51,
  keyR: 0x52,
  keyS: 0x53,
  keyT: 0x54,
  keyU: 0x55,
  keyV: 0x56,
  keyW: 0x57,
  keyX: 0x58,
  keyY: 0x59,
  keyZ: 0x5a,
};

var _parentWindow = window.parent;
var _parentDocument = window.parent.document;

var _hotkeyMap = {};

function _hotkeyManagerPluginInit() {
  var handleKeyDownOrUp = function (eventType, event) {
    var hotKey = Object.values(_hotkeyMap).find(function (value) {
      if (event.which != knownVirtualKeyCodes[value.keyCode]) {
        return false;
      }
      return !(value.modifiers || [])
        .map(function (e) {
          if (e == "shift") {
            return event.shiftKey;
          } else if (e == "control") {
            return event.ctrlKey;
          } else if (e == "alt") {
            return event.altKey;
          } else if (e == "meta") {
            return event.metaKey;
          }
        })
        .includes(false);
    });
    if (hotKey != null) {
      _parentDocument
        .getElementById(window.flutterApp.windowIframeId)
        .contentWindow.postMessage({ eventType, hotKey }, "*");
    }
  };

  _parentDocument.onkeydown = (e) => handleKeyDownOrUp("onKeyDown", e);
  _parentDocument.onkeyup = (e) => handleKeyDownOrUp("onKeyUp", e);
}

function _hotkeyManagerPluginUninit() {
  _parentDocument.onkeyup = null;
  _parentDocument.onkeydown = null;
}

function hotkeyManagerPluginRegister(hotkey) {
  if (Object.values(_hotkeyMap).length == 0) {
    _hotkeyManagerPluginInit();
  }
  _hotkeyMap[hotkey.identifier] = hotkey;
}

function hotkeyManagerPluginUnregister(hotkey) {
  _hotkeyMap[hotkey.identifier] = null;
  delete _hotkeyMap[hotkey.identifier];

  if (Object.values(_hotkeyMap).length == 0) {
    _hotkeyManagerPluginUninit();
  }
}
