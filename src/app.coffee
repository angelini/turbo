class Turbo.App

  @sendMessage: do =>
    messageId = 0
    callbackFunctions = {}

    port = chrome.extension.connect(name: "#{chrome.devtools.inspectedWindow.tabId}")

    port.onMessage.addListener (msg) ->
      if cb = callbackFunctions[msg.id]
        cb(msg.data)
        delete callbackFunctions[msg.id] if msg.options.close

    (msg, cb) =>
      id = messageId++
      cb ?= ->
      callbackFunctions[id] = cb
      port.postMessage(data: msg, id: id)

  start: ->
    console.log 'Started'
