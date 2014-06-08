class Turbo.View

  constructor: ->
    @_value = {}
    @_renders = {_fns: [@render.bind(this)]}

  getValue: (keys...) ->
    result = @_value
    for key in keys
      result[key] ||= {}
      result = result[key]
    result

  setValue: (keys..., value) ->
    key = _.last(keys)
    parent = @getValue(keys.slice(0, -1)...)

    if key
      parent[key] = _.extend(parent[key] || {}, value)
    else
      parent = _.extend(parent, value)

    @callRenderHooks(keys...)

  getRenderHook: (keys...) ->
    result = @_renders
    for key in keys
      result[key] ||= {_fns: []}
      result = result[key]
    result

  addRenderHook: (keys..., fn) ->
    key = keys.pop()
    hook = @getRenderHook(keys...)

    if key
      hook[key] ||= {_fns: []}
      hook[key]._fns.push(fn)
    else
      hook._fns.push(fn)

  callRenderHooks: (keys...) ->
    value = @getValue(keys...)
    hook = @getRenderHook(keys...)

    fn(value) for fn in hook._fns if _.size(value)

    for key of hook
      if key != '_fns'
        @callRenderHooks(keys.concat(key)...)

    return

  render: ->