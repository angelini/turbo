window.addEventListener 'message', (event) ->
  if event.data.for is 'turbo'
    msg = {id: event.data.id, data: JSON.parse(event.data.data), options: event.data.options}
    chrome.runtime.sendMessage(msg)

chrome.runtime.onMessage.addListener (msg, sender) ->
  window.postMessage({for: 'turbo.inspector', id: msg.id, data: msg.data, options: msg.options}, '*')
