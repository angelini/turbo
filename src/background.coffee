log = (m...) ->
  console.log(['[background]'].concat(m)...)

chrome.runtime.onConnect.addListener (extensionPort) ->

  log('connected', extensionPort)
  contentPort = chrome.tabs.connect(parseInt(extensionPort.name, 10))

  extensionPort.onMessage.addListener (msg) ->
    log('message', 'from:extension', msg)
    contentPort.postMessage(msg)

  extensionPort.onDisconnect.addListener ->
    log('disconnect', 'from:extension')
    contentPort.disconnect()

  contentPort.onMessage.addListener (msg, sender) ->
    log('message', 'from:content', msg)
    extensionPort.postMessage(msg)

  contentPort.onDisconnect.addListener ->
    log('disconnect', 'from:content')
    extensionPort.disconnect()
