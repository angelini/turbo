class Turbo.Contexts extends Turbo.View

  @init: ($content) ->
    Turbo.App.log('contexts:init')
    instance = new Turbo.Contexts($content)
    instance.fetch()
    instance.fetchCurrent()

  constructor: (@$node) ->
    super
    Turbo.App.onSelectionChange => @fetchCurrent()
    @addSubRender('current', @renderCurrent.bind(this))

  fetch: ->
    Turbo.App.sendMessage type: 'context', ({context}) =>
      @setValue({context})

  fetchCurrent: ->
    Turbo.App.sendMessage type: 'current-context', ({context, keypath}) =>
      @setSubValue('current', {context, keypath})

  render: (data) ->
    @$node.html(_.template(TEMPLATES.root, data))
    new InspectorJSON({
      element: @$node.find('.context-json')[0]
      json: data.context
    })

  renderCurrent: (data) ->
    @$node.find('.current').html(_.template(TEMPLATES.current, data))
    new InspectorJSON({
      element: @$node.find('.current-json')[0]
      json: data.context
    })


TEMPLATES =
  root: """
    <header>
      <h1>Contexts</h1>
    </header>
    <div>
      <h3>Context</h3>
      <div class="context-json"></div>

      <div class="current"></div>
    </div>
  """

  current: """
    <h3>Keypaths</h3>
    <div><%= keypath %></div>

    <h3>Current</h3>
    <div class="current-json"></div>
  """