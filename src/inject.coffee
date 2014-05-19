Turbo.injectInspector = (cb) ->
  chrome.devtools.network.onNavigated.addListener ->
    Turbo.App.stop()
    window.location.reload()

  req = $.get(chrome.extension.getURL('dist/inspector.js'))
  req.done (script) ->
    chrome.devtools.inspectedWindow.eval(script, cb)

$ ->
  Turbo.injectInspector -> Turbo.App.start()
