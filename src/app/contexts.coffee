class Turbo.Contexts

  @init: ($content) ->
    instance = new Turbo.Contexts($content)
    instance.render()

  constructor: (@$node) ->
    Turbo.App.log('contexts:init')

  render: () ->
    @$node.html(TEMPLATES.root)

TEMPLATES =
  root: """
    <header>
      <h1>Contexts</h1>
    </header>
    <div>
      <p>Hello World</p>
    </div>
  """
