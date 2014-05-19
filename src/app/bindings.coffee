class Turbo.Bindings

  @init: ($content) ->
    instance = new Turbo.Bindings()
    instance.render($content)

    Turbo.App.log('bindings:init')
    Turbo.App.sendMessage type: 'ping', (res) ->
      Turbo.App.log('response', res)

  render: ($content) ->
    $content.html(TEMPLATES.root)

TEMPLATES =
  root: """
    <header>
      <h1>Bindings</h1>
    </header>
    <div>
      <p>Hello World</p>
    </div>
  """
