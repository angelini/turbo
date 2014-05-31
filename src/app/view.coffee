class Turbo.View

  constructor: ->
    @_subRenders = {}
    @_value = {}

  getValue: -> @_value

  setValue: (value) ->
    @render(@_value = value)

  setSubValue: (key, value) ->
    @_value[key] = value
    @_subRenders[key]?(value)

  addSubRender: (key, fn) ->
    @_subRenders[key] = fn

  render: ->