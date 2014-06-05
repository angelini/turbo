class Turbo.Messenger

  @connect: ->
    new Turbo.Messenger(chrome.devtools.inspectedWindow.tabId)

  constructor: (tabId) ->
    @messageId = 0
    @handlers = {}

    @port = chrome.runtime.connect(name: "#{tabId}")

    @port.onMessage.addListener (msg) =>
      Turbo.App.log('message', msg)

      if handler = @handlers[msg.id]
        handler.fn(msg.data)
        delete @handlers[msg.id] if !handler.keepAlive

  send: (msg, cb) ->
    @_send(msg, cb, false)

  on: (msg, cb) ->
    @_send(msg, cb, true)

  off: (msg, cb) ->
    toRemove = []

    for id, handler of @handlers
      if handler.msg == msg
        if !cb || cb == handler.fn
          delete @handlers[id]
          toRemove.push(id)

    @send({type: 'off', ids: toRemove})

  _send: (msg, cb, keepAlive) ->
    id = @messageId++
    @handlers[id] = {msg, keepAlive, fn: cb || ->}
    @port.postMessage(data: msg, id: id)

  disconnect: ->
    @port.disconnect()

  onSelectionChange: (cb) ->
    chrome.devtools.panels.elements.onSelectionChanged.addListener(cb)