Turbo.injectInspector = (cb) ->
  chrome.devtools.network.onNavigated.addListener ->
    Turbo.App.stop()
    window.location.reload()

  underscore = $.get(chrome.extension.getURL('bower_components/underscore/underscore.js'))
  inspector = $.get(chrome.extension.getURL('dist/inspector.js'))

  $.when(underscore, inspector).done (underscoreRes, inspectorRes) ->
    chrome.devtools.inspectedWindow.eval([underscoreRes[0], inspectorRes[0]].join(';\n'), cb)

$ ->
  Turbo.injectInspector ->
    Turbo.App.start(Turbo.Messenger.connect())