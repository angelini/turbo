chrome.extension.onConnect.addListener (port) ->
  port.onMessage.addListener (msg) ->
    chrome.tabs.sendMessage(parseInt(port.name, 10), msg)

  chrome.extension.onMessage.addListener (msg, sender) ->
    port.postMessage(msg)
