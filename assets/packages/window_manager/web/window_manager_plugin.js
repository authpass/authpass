var _parentWindow = window.parent;
var _parentDocument = window.parent.document;

function windowManagerPluginInit() {
  var el = _parentDocument.getElementById(window.flutterApp.windowId);

  var pos1 = 0;
  var pos2 = 0;
  var pos3 = 0;
  var pos4 = 0;
  if (_parentDocument.getElementById(window.flutterApp.windowHeaderId)) {
    // if present, the header is where you move the DIV from:
    _parentDocument.getElementById(
      window.flutterApp.windowHeaderId
    ).onmousedown = dragMouseDown;
  } else {
    // otherwise, move the DIV from anywhere inside the DIV:
    el.onmousedown = dragMouseDown;
  }

  function dragMouseDown(e) {
    e = e || _parentWindow.event;
    e.preventDefault();
    // get the mouse cursor position at startup:
    pos3 = e.clientX;
    pos4 = e.clientY;
    _parentDocument.onmouseup = closeDragElement;
    // call a function whenever the cursor moves:
    _parentDocument.onmousemove = elementDrag;
  }

  function elementDrag(e) {
    e = e || _parentWindow.event;
    e.preventDefault();
    // calculate the new cursor position:
    pos1 = pos3 - e.clientX;
    pos2 = pos4 - e.clientY;
    pos3 = e.clientX;
    pos4 = e.clientY;
    // set the element's new position:
    el.style.top = el.offsetTop - pos2 + "px";
    el.style.left = el.offsetLeft - pos1 + "px";
  }

  function closeDragElement() {
    // stop moving when mouse button is released:
    _parentDocument.onmouseup = null;
    _parentDocument.onmousemove = null;
  }
}

function windowManagerPluginShow() {
  var el = _parentDocument.getElementById(window.flutterApp.windowId);
  el.style.display = "flex";
}

function windowManagerPluginHide() {
  var el = _parentDocument.getElementById(window.flutterApp.windowId);
  el.style.display = "none";
}

function windowManagerPluginIsVisible() {
  var el = _parentDocument.getElementById(window.flutterApp.windowId);
  return { isVisible: el.style.display !== "none" };
}

function windowManagerPluginIsMaximized() {
  var el = _parentDocument.getElementById(window.flutterApp.windowId);
  return {
    isMaximized:
      _parentWindow.innerWidth == el.offsetWidth &&
      _parentWindow.innerHeight == el.offsetHeight,
  };
}

function windowManagerPluginMaximize() {
  var el = _parentDocument.getElementById(window.flutterApp.windowId);

  el.setAttribute("data-last-top", el.offsetTop);
  el.setAttribute("data-last-left", el.offsetLeft);
  el.setAttribute("data-last-width", el.offsetWidth);
  el.setAttribute("data-last-height", el.offsetHeight);

  el.style.top = "0px";
  el.style.left = "0px";
  el.style.width = `${_parentWindow.innerWidth}px`;
  el.style.height = `${_parentWindow.innerHeight}px`;
}

function windowManagerPluginUnmaximize() {
  var el = _parentDocument.getElementById(window.flutterApp.windowId);

  var offsetTop = el.getAttribute("data-last-top");
  var offsetLeft = el.getAttribute("data-last-left");
  var offsetWidth = el.getAttribute("data-last-width");
  var offsetHeight = el.getAttribute("data-last-height");

  el.style.top = `${offsetTop}px`;
  el.style.left = `${offsetLeft}px`;
  el.style.width = `${offsetWidth}px`;
  el.style.height = `${offsetHeight}px`;
}

function windowManagerPluginIsFullScreen() {
  var isFullScreen =
    _parentDocument.webkitIsFullScreen ||
    _parentDocument.mozFullScreen ||
    false;

  return { isFullScreen };
}

function windowManagerPluginSetFullScreen() {
  var el = _parentDocument.getElementById(window.flutterApp.windowId);

  var isFullScreen =
    _parentDocument.webkitIsFullScreen ||
    _parentDocument.mozFullScreen ||
    false;

  el.requestFullScreen =
    el.requestFullScreen ||
    el.webkitRequestFullScreen ||
    el.mozRequestFullScreen ||
    function () {
      return false;
    };
  _parentDocument.cancelFullScreen =
    _parentDocument.cancelFullScreen ||
    _parentDocument.webkitCancelFullScreen ||
    _parentDocument.mozCancelFullScreen ||
    function () {
      return false;
    };

  isFullScreen ? _parentDocument.cancelFullScreen() : el.requestFullScreen();

  var headerEl = _parentDocument.getElementById(
    window.flutterApp.windowHeaderId
  );
  headerEl.style.display = isFullScreen ? "flex" : "none";
}

function windowManagerPluginGetBounds() {
  var el = _parentDocument.getElementById(window.flutterApp.windowId);

  var elRect = el.getBoundingClientRect();

  return {
    x: elRect.left,
    y: elRect.bottom,
    width: el.offsetWidth,
    height: el.offsetHeight,
  };
}

function windowManagerPluginSetBounds(bounds) {
  var el = _parentDocument.getElementById(window.flutterApp.windowId);

  el.style.width = `${bounds.width}px`;
  el.style.height = `${bounds.height}px`;
  el.style.left = `${bounds.x}px`;
  el.style.bottom = `${bounds.y}px`;
}
