suite 'Turbo.Bindings', ->

  setup ->
    @view = new Turbo.Bindings($('#fixtures'))
    @bindings = [
      {id: 1, node: 'input', type: 'bind', definition: 'foo', values: ['bar', 'baz']},
      {id: 2, node: 'div#id', type: 'bind', definition: 'other', values: ['test']},
      {id: 2, node: 'div#id', type: 'bind-show', definition: 'show', values: ['true']},
      {id: 3, node: 'div.class', type: 'define', definition: '{a: b}', values: [null]},
    ]

  test '.applyFilters only returns bindings which contain filtered characters', ->
    @view.filters = node: 'div'
    filtered = @view.applyFilters(@bindings)
    assert.equal 3, filtered.length
    assert.equal 'div#id', filtered[0].node

    @view.filters = type: 'ind'
    filtered = @view.applyFilters(@bindings)
    assert.equal 3, filtered.length

    @view.filters = node: 'div', definition: 'how'
    filtered = @view.applyFilters(@bindings)
    assert.equal 'div#id', filtered[0].node

  test '.applyFilters only filters based on the most recent binding value', ->
    @view.filters = value: 'bar'
    filtered = @view.applyFilters(@bindings)
    assert.equal 1, filtered.length

    @view.filters = value: 'baz'
    filtered = @view.applyFilters(@bindings)
    assert.equal 0, filtered.length

  test '.subscribeToValues appends new values to bindings', ->
    newBindings = [
      {type: 'bind', definition: 'other', value: 'new'},
      {type: 'bind-show', definition: 'show', value: 'true'}
    ]
    @stub(Turbo.App, 'on').callsArgWith(1, 2, newBindings)

    @view._value = {bindings: @bindings, filtered: @bindings}
    @view.subscribeToValues([1,2,3])

    state = @view.getValue()
    assert.deepEqual ['new', 'test'], state.bindings[1].values
    assert.deepEqual ['true'], state.bindings[2].values