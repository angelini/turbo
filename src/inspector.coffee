log = (m...) ->
  console.log(['[inspector]'].concat(m)...)

bindingsCount = ->
  _.reduce(Bindings._elements, ((count, e) -> count + _.size(e.bindings)), 0)

keypathList = (node) ->
  keypaths = []

  while node && node != document
    if key = node.getAttribute('context')
      keypaths.unshift(key)

    node = node.parentNode

  return keypaths

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

      when 'bindings'
        cb(count: bindingsCount())

      when 'contexts'
        result = context: window.context

        if $0
          _.extend result,
            current: Bindings.context($0)
            keypaths: keypathList($0)

        cb(result)

      else
        log('Unknown message', msg)

window.inspector = new TurboInspector()
