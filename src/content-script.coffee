log = (m...) ->
  console.log(['[content]'].concat(m)...)

chrome.runtime.onConnect.addListener (backgroundPort) ->

  log('connected', backgroundPort)

  window.addEventListener 'message', tabListener = (event) ->
    if event.data.for is 'turbo'
      log('message', 'from:inspector', event.data)
      msg = id: event.data.id, data: JSON.parse(event.data.data), options: event.data.options
      backgroundPort.postMessage(msg)

  backgroundPort.onMessage.addListener (msg) ->
    log('message', 'from:background', msg)
    window.postMessage({for: 'turbo.inspector', id: msg.id, data: msg.data, options: msg.options}, '*')

  backgroundPort.onDisconnect.addListener ->
    log('disconnect', 'from:background')
    window.removeEventListener(tabListener)
    window.postMessage({for: 'turbo.inspector', data: {type: 'disconnect'}}, '*')
