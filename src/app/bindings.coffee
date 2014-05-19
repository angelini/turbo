class Turbo.Bindings

  @init: ($content) ->
    Turbo.App.log('bindings:init')

    instance = new Turbo.Bindings($content)
    instance.render()

  constructor: (@$node) ->
    @count = 0

    Turbo.App.sendMessage type: 'bindings:init', (res) =>
      @count = res.count
      @render()

  render: () ->
    @$node.html(_.template(TEMPLATES.root, count: @count))

TEMPLATES =
  root: """
    <header>
      <h1>Bindings</h1>
    </header>
    <div>
      <div>Binding Count: <%= count %></div>
    </div>
  """
