nodeName = (node) ->
  name = node.type
  name += " ##{node.id}" if (node.id)
  name += " .#{node.className.split(' ').join('.')}" if (node.className)
  return name

extractBindings = (acc, element) ->
  for binding in element.bindings
    result =
      node: nodeName(element.node)
      type: binding.type
      definition: binding.definition
    acc.push(result)

  return acc

emptyTable = ($table) ->
  $table.find('tr').slice(1).remove()

testFilter = (filter, val) ->
  return true if !filter
  val.indexOf(filter) >= 0

class Turbo.Bindings

  @init: ($content) ->
    Turbo.App.log('bindings:init')
    instance = new Turbo.Bindings($content)
    instance.fetch(instance.render.bind(instance))

  constructor: (@$node) ->
    @cache = {}
    @filters = {}

    @$node.on 'keyup', '.js-node', @updateFilter.bind(this, 'node')
    @$node.on 'keyup', '.js-type', @updateFilter.bind(this, 'type')

  updateFilter: (filter) ->
    @filters[filter] = @$node.find(".js-#{filter}").val()
    @renderList(@cache.bindings)

  fetch: (cb) ->
    Turbo.App.sendMessage type: 'bindings', ({count, elements}) =>
      bindings = _.reduce(elements, extractBindings, [])
      cb(@cache = {count, bindings})

  render: (data) ->
    @$node.html(_.template(TEMPLATES.root, data))
    @renderList(data.bindings)

  renderList: (bindings) ->
    $table = @$node.find('table')
    emptyTable($table)

    filtered = _.filter bindings, (binding) =>
      return false if !testFilter(@filters.node, binding.node)
      return false if !testFilter(@filters.type, binding.type)
      return true

    $table.append(_.template(TEMPLATES.list, bindings: filtered))

TEMPLATES =
  root: """
    <header>
      <h1>Bindings</h1>
    </header>
    <div>
      <div>Binding Count: <%= count %></div>

      <table class="table">
        <tr>
          <th>
            <label>Node</label>
            <input class="js-node" type="text">
          </th>
          <th>
            <label>Type</label>
            <input class="js-type" type="text">
          </th>
          <th>
            <label>Definition</label>
            <input class="js-definition" type="text">
          </th>
          <th>
            <label>Value</label>
            <input class="js-value" type="text">
          </th>
        </tr>
      </table>
    </div>
  """

  list: """
    <% _.each(bindings, function(binding) { %>
      <tr>
        <td><%= binding.node %></td>
        <td><%= binding.type %></td>
        <td><%= binding.definition %></td>
        <td><%= binding.value %></td>
      </tr>
    <% }) %>
  """