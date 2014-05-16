Turbo.injectDebugger = (cb) ->
  chrome.devtools.network.onNavigated.addListener ->
    window.location.reload()

  req = $.get(chrome.extension.getURL('dist/inspector.js'))
  req.done (script) ->
    chrome.devtools.inspectedWindow.eval(script, cb)

$ ->
  Turbo.injectDebugger -> Turbo.App.start()
