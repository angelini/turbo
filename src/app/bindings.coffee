class Turbo.Bindings

  @init: ($content) ->
    Turbo.App.log('bindings:init')
    instance = new Turbo.Bindings($content)
    instance.fetch(instance.render.bind(instance))

  constructor: (@$node) ->

  fetch: (cb) ->
    Turbo.App.sendMessage(type: 'bindings', cb)

  render: (data) ->
    @$node.html(_.template(TEMPLATES.root, data))

TEMPLATES =
  root: """
    <header>
      <h1>Bindings</h1>
    </header>
    <div>
      <div>Binding Count: <%= count %></div>
    </div>
  """
