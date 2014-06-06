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
      value: binding.value
    acc.push(result)
  return acc

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
    @$node.on 'keyup', '.js-definition', @updateFilter.bind(this, 'definition')
    @$node.on 'keyup', '.js-value', @updateFilter.bind(this, 'value')

    @addSubRender('filtered', @renderList.bind(this))

  updateFilter: (filter) ->
    @filters[filter] = @$node.find(".js-#{filter}").val()
    @setSubValue('filtered', @applyFilters(@getValue()['bindings']))

  applyFilters: (bindings) ->
    _.filter bindings, (binding) =>
      return false if !testFilter(@filters.node, binding.node)
      return false if !testFilter(@filters.type, binding.type)
      return false if !testFilter(@filters.definition, binding.definition)
      return false if !testFilter(@filters.value, binding.value)
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
    $tbody = @$node.find('tbody')
    $tbody.html(_.template(TEMPLATES.list, bindings: filtered))


TEMPLATES =
  root: """
    <header>
      <h1>Bindings<span class="comment"> - count: <%= bindings.length %></span></h1>
    </header>
    <div>
      <table>
        <thead>
          <tr>
            <th>
              <input class="js-node" type="text" placeholder="Node">
            </th>
            <th>
              <input class="js-type" type="text" placeholder="Type">
            </th>
            <th>
              <input class="js-definition" type="text" placeholder="Definition">
            </th>
            <th>
              <input class="js-value" type="text" placeholder="Value">
            </th>
          </tr>
        </thead>
        <tbody class="striped"></tbody>
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