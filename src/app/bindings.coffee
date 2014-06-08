nodeName = (node) ->
  name = node.type
  name += "##{node.id}" if (node.id)
  name += ".#{node.className.split(' ').join('.')}" if (node.className)
  return name

extractBindings = (acc, element, id) ->
  for binding in element.bindings
    acc.push
      id: parseInt(id, 10)
      index: acc.length
      node: nodeName(element.node)
      type: binding.type
      definition: binding.definition
      values: [binding.value]
  return acc

testFilter = (filter, val) ->
  return true if !filter
  val?.indexOf(filter) >= 0


class Turbo.Bindings extends Turbo.View

  @init: ($content) ->
    Turbo.App.log('bindings:init')
    instance = new Turbo.Bindings($content)
    instance.fetch()

  @die: ->
    Turbo.App.log('bindings:die')
    Turbo.App.off {type: 'binding-values'}

  constructor: (@$node) ->
    super
    @filters = {}

    @$node.on 'click', '.js-binding-row', @selectRow.bind(this)

    @$node.on 'keyup', '.js-node', @updateFilter.bind(this, 'node')
    @$node.on 'keyup', '.js-type', @updateFilter.bind(this, 'type')
    @$node.on 'keyup', '.js-definition', @updateFilter.bind(this, 'definition')
    @$node.on 'keyup', '.js-value', @updateFilter.bind(this, 'value')

    @addRenderHook('list', @renderList.bind(this))
    @addRenderHook('list', 'selected', @renderSelected.bind(this))

  applyFilters: (bindings) ->
    _.filter bindings, (binding) =>
      return false if !testFilter(@filters.node, binding.node)
      return false if !testFilter(@filters.type, binding.type)
      return false if !testFilter(@filters.definition, binding.definition)
      return false if !testFilter(@filters.value, _.first(binding.values))
      return true

  fetch: ->
    Turbo.App.sendMessage type: 'bindings', ({elements}) =>
      @subscribeToValues(_.keys(elements))

      bindings = _.reduce(elements, extractBindings, [])
      filtered = @applyFilters(bindings)
      @setValue(list: {bindings, filtered})

  subscribeToValues: (ids) ->
    Turbo.App.on {type: 'binding-values', ids}, (id, bindings) =>
      list = @getValue('list')

      for binding in bindings
        old = _.find list.bindings, (oldBinding) ->
          oldBinding.id == id &&
          oldBinding.type == binding.type &&
          oldBinding.definition == binding.definition

        if old && !_.isEqual(binding.value, _.first(old.values))
          old.values.unshift(binding.value)

      @setValue('list', filtered: @applyFilters(list.bindings))

  updateFilter: (filter) ->
    @filters[filter] = @$node.find(".js-#{filter}").val()
    @setValue('list', filtered: @applyFilters(@getValue().list.bindings))

  selectRow: (event) ->
    $rows = @$node.find('.body li')
    $row = $(event.target).parent('li')
    list = @getValue('list')

    filteredIndex = $rows.index($row)
    index = list.bindings.indexOf(list.filtered[filteredIndex])
    values = list.bindings[index].values
    @setValue('list', 'selected', {index, values})

  render: (data) ->
    @$node.html(_.template(TEMPLATES.root, data))

  renderList: (list) ->
    $tbody = @$node.find('.table .body')
    $tbody.html(_.template(TEMPLATES.list, bindings: list.filtered))

  renderSelected: (selected) ->
    @$node.find('.js-history-row').remove()

    $row = @$node.find(".js-index-#{selected.index}")
    $row.append(_.template(TEMPLATES.history, values: selected.values)) if $row


TEMPLATES =
  root: """
    <header>
      <h1>Bindings<span class="comment"> - count: <%= list.bindings.length %></span></h1>
    </header>
    <div class="table vbox">
      <div class="header">
        <div class="hbox">
          <input class="js-node" type="text" placeholder="Node">
          <input class="js-type" type="text" placeholder="Type">
          <input class="js-definition" type="text" placeholder="Definition">
          <input class="js-value" type="text" placeholder="Value">
        </div>
      </div>
      <ul class="striped body"></ul>
    </div>
  """

  list: """
    <% _.each(bindings, function(binding) { %>
      <li class="hbox wrap js-binding-row js-index-<%= binding.index %>">
        <div class="col"><%= binding.node %></div>
        <div class="col"><%= binding.type %></div>
        <div class="col"><%= binding.definition %></div>
        <div class="col"><%= _.first(binding.values) %></div>
      </li>
    <% }) %>
  """

  history: """
    <div class="full block vbox js-history-row">
      <h2>History</h2>
      <% _.each(values, function(value) { %>
        <div><%= value %></div>
      <% }) %>
    </tr>
  """