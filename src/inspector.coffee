log = (m...) ->
  console.log(['[inspector]'].concat(m)...)

bindingsCount = ->
  _.reduce(Bindings._elements, ((count, e) -> count + _.size(e.bindings)), 0)

boundElements = ->
  elements = {}

  for element in document.getElementsByTagName("*")
    if (id = element.bindingId) && (definition = Bindings._elements[id])
      keypath = Bindings._keypathForKey(Bindings.contextKey(element))
      context = Bindings._getValue(Bindings._rootContext, keypath)

      bindings = []
      for type of Bindings.bindingTypes when definition = element.getAttribute(type)
        bindings.push({type, definition})

      continue unless bindings.length

      elements[id] =
        context: context
        bindings: bindings
        node:
          id: element.id
          className: element.className
          type: element.nodeName.toLowerCase()

  return elements


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
        result =
          count: bindingsCount()
          elements: boundElements()
        cb(result)

      when 'context'
        cb(context: window.context)

      when 'current-context'
        result =
          context: Bindings.context($0)
          keypath: Bindings.contextKey($0)
        cb(result)

      else
        log('Unknown message', msg)

window.inspector = new TurboInspector()