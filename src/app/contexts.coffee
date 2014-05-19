class Turbo.Contexts

  @init: ($content) ->
    instance = new Turbo.Contexts()
    instance.render($content)

  render: ($content) ->
    $content.html(TEMPLATES.root)

TEMPLATES =
  root: """
    <header>
      <h1>Contexts</h1>
    </header>
    <div>
      <p>Hello World</p>
    </div>
  """
