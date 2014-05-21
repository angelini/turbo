nodeName = (node) ->
  name = node.type
  name += " ##{node.id}" if (node.id)
  name += " .#{node.className.join('.')}" if (node.className)
  return name

extractBindings = (acc, element) ->
  for binding in element.bindings
    result =
      node: nodeName(element.node)
      type: binding.type
      definition: binding.definition
    acc.push(result)

  return acc

class Turbo.Bindings

  @init: ($content) ->
    Turbo.App.log('bindings:init')
    instance = new Turbo.Bindings($content)
    instance.fetch(instance.render.bind(instance))

  constructor: (@$node) ->

  fetch: (cb) ->
    Turbo.App.sendMessage type: 'bindings', ({count, elements}) ->
      bindings = _.reduce(elements, extractBindings, [])
      cb({count, bindings})

  render: (data) ->
    @$node.html(_.template(TEMPLATES.root, data))

TEMPLATES =
  root: """
    <header>
      <h1>Bindings</h1>
    </header>
    <div>
      <div>Binding Count: <%= count %></div>

      <table class="table">
        <tr>
          <th>Node</th>
          <th>Type</th>
          <th>Definition</th>
          <th>Value</th>
        </tr>

        <% _.each(bindings, function(binding) { %>
          <tr>
            <td><%= binding.node %></td>
            <td><%= binding.type %></td>
            <td><%= binding.definition %></td>
            <td><%= binding.value %></td>
          </tr>
        <% }) %>
      </table>
    </div>
  """
