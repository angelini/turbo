suite 'Turbo.Messenger', ->

  setup ->
    @port =
      onMessage: {addListener: @spy()}
      disconnect: @spy()
      postMessage: @spy()

    @stub(chrome.runtime, 'connect').returns(@port)
    @messenger = new Turbo.Messenger

  test '::send posts a message with an id > 0', ->
    @messenger.send({type: 'foo'})
    assert.ok @port.postMessage.calledWith
      data: {type: 'foo'}
      id: 1