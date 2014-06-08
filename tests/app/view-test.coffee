suite 'Turbo.View', ->

  setup ->
    @view = new Turbo.View
    @view._value =
      foo: 'bar'
      nested: {inner: 'baz'}

  test '.getValue with no keys returns the root value', ->
    assert.deepEqual @view._value, @view.getValue()

  test '.getValue can read nested values', ->
    assert.equal 'baz', @view.getValue('nested', 'inner')

  test '.setValue with no keys will mixin to the root value', ->
    @view.setValue({test: 'new'})
    assert.equal 'new', @view.getValue().test
    assert.equal 'bar', @view.getValue().foo

  test '.setValue will mixin to nested values', ->
    @view.setValue('nested', {test: 'new'})
    assert.equal 'new', @view.getValue('nested').test
    assert.equal 'baz', @view.getValue('nested').inner

  test '.setValue will create parent objects if they do not exist', ->
    @view.setValue('first', 'second', 'third', {test: 'new'})
    assert.equal 'new', @view.getValue('first', 'second', 'third').test

  test '.getRenderHook with no keys returns the root hook', ->
    assert.deepEqual @view._renders, @view.getRenderHook()

  test '.addRenderHook with no keys will push to the root hook', ->
    @view.addRenderHook(fn = ->)
    assert.equal 2, @view._renders._fns.length
    assert.equal fn, @view._renders._fns[1]

  test '.addRenderHook will add fns to nested hooks', ->
    @view.addRenderHook('nested', 'inner', fn = ->)
    assert.equal 1, @view.getRenderHook('nested', 'inner')._fns.length
    assert.equal fn, @view.getRenderHook('nested', 'inner')._fns[0]

  test '.callRenderHooks will call all children hooks', ->
    @view.addRenderHook('nested', first = @spy())
    @view.addRenderHook('nested', 'inner', second = @spy())
    @view.setValue('nested', inner: 'buz')
    assert.deepEqual {inner: 'buz'}, first.args[0][0]
    assert.equal 'buz', second.args[0][0]