class TurboInspector

  init: ->
    @messageListener()

  messageListener: ->
    window.addEventListener 'message', (event) =>
      console.log('event', event)
      if event.data.for is 'turbo.inspector'
        @handleMessage event.data.data, (res, options = {}) =>
          data = JSON.stringify(res)
          window.postMessage({id: event.data.id, for: 'turbo', data, options}, '*')

  handleMessage: (msg, cb) ->
    switch msg.type
      when 'ping'
        cb(type: 'pong')
      else
        console.log('Unknown message', msg)

window.TurboInspector = TurboInspector
window._inspector = new TurboInspector()
window._inspector.init()
