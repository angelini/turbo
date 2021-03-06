log = (m...) ->
  console.log(['[inspector]'].concat(m)...)

bindingValue = (type, context, definition) ->
  key = Bindings._keypathForKey(definition)
  switch type
    when 'bind' then Bindings._getValue(context, key)
    when 'bind-show' then !!Bindings._getValue(context, key)
    when 'bind-class' then Bindings._getValue(context, key)
    else null

extractElementBindings = (element) ->
  key = Bindings.contextKey(element)
  keypath = if key then Bindings._keypathForKey(key) else []
  context = Bindings._getValue(Bindings._rootContext, keypath)

  bindings = []
  for type of Bindings.bindingTypes when definition = element.getAttribute(type)
    bindings.push({type, definition, value: bindingValue(type, context, definition)})

  return bindings

boundElements = ->
  elements = {}

  for element in document.getElementsByTagName("*")
    if (id = element.bindingId) && (definition = Bindings._elements[id])
      bindings = extractElementBindings(element)
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
    @handlers = {}

    window.addEventListener 'message', messageListener = (event) =>
      return if event.data.for != 'turbo.inspector'
      log('message', event.data)

      if (event.data.data.type == 'disconnect')
        window.removeEventListener(messageListener)
        return

      @handleMessage event.data.id, event.data.data, (res, options = {}) =>
        data = JSON.stringify(res)
        window.postMessage({id: event.data.id, for: 'turbo', data, options}, '*')

  handleMessage: (id, msg, cb) ->
    switch msg.type
      when 'ping'
        cb(type: 'pong')

      when 'bindings'
        cb(elements: boundElements())

      when 'bindings-values'
        @handlers[id] = @listenForChanges(msg.ids, cb)

      when 'context'
        cb(context: window.context)

      when 'current-context'
        result =
          context: Bindings.context($0)
          keypath: Bindings.contextKey($0)
        cb(result)

      when 'off'
        for id in msg.ids
          @handlers[id]()
          delete @handlers[id]

      else
        log('Unknown message', msg)

  listenForChanges: (ids, cb) ->
    changeHandlers = {}

    for id in ids
      element = Bindings._elements[id]
      changeHandlers[id] = ->
        cb(id, extractElementBindings(element))

      $(element).on('bindings:change', changeHandlers[id])

    return ->
      for id in ids
        element = Bindings._elements[id]
        $(element).off('bindings:change', changeHandlers[id])

window.inspector = new TurboInspector()