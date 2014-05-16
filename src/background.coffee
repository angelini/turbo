chrome.runtime.onConnect.addListener (port) ->
  port.onMessage.addListener (msg) ->
    chrome.tabs.sendMessage(parseInt(port.name, 10), msg)

  chrome.runtime.onMessage.addListener (msg, sender) ->
    console.log('last', msg, sender)
    port.postMessage(msg)
