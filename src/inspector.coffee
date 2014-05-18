log = (m...) ->
  console.log(['[inspector]'].concat(m)...)

class TurboInspector

  init: ->
    window.addEventListener 'message', messageListener = (event) =>
      if event.data.for is 'turbo.inspector'
        log('message', event.data)

        if (event.data.data.type == 'disconnect')
          window.removeEventListener(messageListener)
          return

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
