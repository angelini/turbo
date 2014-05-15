class window.TurboInspector

  messageListener: ->
    window.addEventListener 'message', (event) =>
      if event.data.for is 'turbo.inspector'
        @handleMessage event.data.data, (res, options = {}) =>
          data = JSON.stringify BatmanDebug.prettify(res)
          window.postMessage {id: event.data.id, for: 'turbo', data, options}, '*'

  handleMessage: (msg, cb) ->
    switch msg.type
      when 'ping'
        cb type: 'pong'
      else
        console.log 'Unknown message', msg
