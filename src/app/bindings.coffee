nodeName = (node) ->
  name = node.type
  name += "##{node.id}" if (node.id)
  name += ".#{node.className.split(' ').join('.')}" if (node.className)
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


class Turbo.Bindings extends Turbo.View

  @init: ($content) ->
    Turbo.App.log('bindings:init')
    instance = new Turbo.Bindings($content)
    instance.fetch()

  constructor: (@$node) ->
    super
    @filters = {}

    @$node.on 'keyup', '.js-node', @updateFilter.bind(this, 'node')
    @$node.on 'keyup', '.js-type', @updateFilter.bind(this, 'type')

    @addSubRender('filtered', @renderList.bind(this))

  updateFilter: (filter) ->
    @filters[filter] = @$node.find(".js-#{filter}").val()
    @setSubValue('filtered', @applyFilters(@getValue()['bindings']))

  applyFilters: (bindings) ->
    _.filter bindings, (binding) =>
      return false if !testFilter(@filters.node, binding.node)
      return false if !testFilter(@filters.type, binding.type)
      return true

  fetch: ->
    Turbo.App.sendMessage type: 'bindings', ({elements}) =>
      bindings = _.reduce(elements, extractBindings, [])
      filtered = @applyFilters(bindings)
      @setValue({bindings, filtered})

  render: (data) ->
    @$node.html(_.template(TEMPLATES.root, data))
    @renderList(data.filtered)

  renderList: (filtered) ->
    $table = @$node.find('table')
    emptyTable($table)
    $table.append(_.template(TEMPLATES.list, bindings: filtered))


TEMPLATES =
  root: """
    <header>
      <h1>Bindings</h1>
    </header>
    <div>
      <div>Binding Count: <%= bindings.length %></div>

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