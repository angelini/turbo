class Turbo.Contexts

  @init: ($content) ->
    Turbo.App.log('contexts:init')
    instance = new Turbo.Contexts($content)
    instance.fetch(instance.render.bind(instance))

  constructor: (@$node) ->
    chrome.devtools.panels.elements.onSelectionChanged.addListener =>
      @fetch(@render.bind(this))

  fetch: (cb) ->
    Turbo.App.sendMessage type: 'contexts', ({current, context, keypaths}) ->
      cb({current, context, keypaths})

  render: (data) ->
    @$node.html(_.template(TEMPLATES.root, data))

    new InspectorJSON({
      element: @$node.find('.context-json')[0]
      json: data.context
    })

    if data.current
      new InspectorJSON({
        element: @$node.find('.current-json')[0]
        json: data.current
      })

TEMPLATES =
  root: """
    <header>
      <h1>Contexts</h1>
    </header>
    <div>
      <% if (keypaths && keypaths.length) { %>
        <h3>Keypaths</h3>
        <ol class="breadcrumb">
          <% _.each(keypaths, function(keypath) { %>
            <li><%= keypath %></li>
          <% }) %>
        </ol>
      <% } %>

      <% if (current) { %>
        <h3>Current</h3>
        <div class="current-json"></div>
      <% } %>

      <h3>Context</h3>
      <div class="context-json"></div>
    </div>
  """
