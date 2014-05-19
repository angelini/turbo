class Turbo.Messenger

  @connect: ->
    new Turbo.Messenger(chrome.devtools.inspectedWindow.tabId)

  constructor: (tabId) ->
    @messageId = 0
    @callbackFunctions = {}

    @port = chrome.runtime.connect(name: "#{tabId}")

    @port.onMessage.addListener (msg) =>
      Turbo.App.log('message', msg)

      if cb = @callbackFunctions[msg.id]
        cb(msg.data)
        delete @callbackFunctions[msg.id]

  send: (msg, cb) ->
    id = @messageId++
    @callbackFunctions[id] = cb || ->
    @port.postMessage(data: msg, id: id)

  disconnect: ->
    @port.disconnect()
