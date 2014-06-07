suite 'Turbo.Messenger', ->

  setup ->
    @port =
      onMessage: {addListener: @spy()}
      disconnect: @spy()
      postMessage: @spy()

    @stub(chrome.runtime, 'connect').returns(@port)
    @messenger = new Turbo.Messenger

  test '.send posts a message with an id > 0', ->
    @messenger.send({type: 'foo'})
    assert.ok @port.postMessage.calledWith
      data: {type: 'foo'}
      id: 1

  test '.send assigns a handler for the callback function', ->
    @messenger.send({type: 'foo'}, fn = ->)
    assert.equal fn, @messenger.handlers[1].fn

  test '.send sets the handler keepAlive flag to false', ->
    @messenger.send({type: 'foo'})
    assert.ok !@messenger.handlers[1].keepAlive

  test '.send can queue up multiple handlers', ->
    @messenger.send({type: 'foo'})
    @messenger.send({type: 'foo'})
    @messenger.send({type: 'foo'})
    assert.equal 3, _.size(@messenger.handlers)

  test '.on sets the handler keepAlive flag to true', ->
    @messenger.on({type: 'foo'})
    assert.ok @messenger.handlers[1].keepAlive

  test '.off sends an off message with a list of IDs to remove', ->
    @messenger.on({type: 'foo'})
    @messenger.off({type: 'foo'})
    assert.deepEqual {type: 'off', ids: ["1"]}, @port.postMessage.args[1][0].data

  test '.off removes all handlers of the same type if no cb is given', ->
    @messenger.on({type: 'foo'})
    @messenger.on({type: 'foo'})
    @messenger.off({type: 'foo'})
    assert.deepEqual ['1', '2'], @port.postMessage.args[2][0].data.ids

  test '.off removes only the specific handler if a cb is given', ->
    @messenger.on({type: 'foo'}, fn = ->)
    @messenger.on({type: 'foo'})
    @messenger.off({type: 'foo'}, fn)
    assert.deepEqual ['1'], @port.postMessage.args[2][0].data.ids