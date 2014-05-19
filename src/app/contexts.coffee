class Turbo.Contexts

  @init: ($content) ->
    Turbo.App.log('contexts:init')

    instance = new Turbo.Contexts($content)
    instance.render()

  constructor: (@$node) ->
    @root = {}

    Turbo.App.sendMessage type: 'contexts:init', (res) =>
      @root = res.context
      @render()

  render: ->
    console.log(JSON.stringify(@root))
    @$node.html(_.template(TEMPLATES.root, root: @root))

TEMPLATES =
  root: """
    <header>
      <h1>Contexts</h1>
    </header>
    <div>
      <pre><%= JSON.stringify(root) %></pre>
    </div>
  """
