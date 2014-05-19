log = (m...) ->
  console.log(['[inspector]'].concat(m)...)

bindingsCount = ->
  _.reduce(Bindings._elements, ((count, e) -> count + _.size(e.bindings)), 0)

class TurboInspector

  constructor: ->
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
      when 'bindings:init'
        cb(count: bindingsCount())
      when 'contexts:init'
        cb(context: window.context)
      else
        console.log('Unknown message', msg)

window.inspector = new TurboInspector()
