class Turbo.MockMessenger

  @connect: ->
    new Turbo.MockMessenger

  send: (msg, cb) ->
    cb(RESPONSES[msg.type])

  on: (msg, cb) ->
    @interval = setInterval ->
      cb(1, [{type: 'bind', definition: 'foo', value: 'bar' + Math.random()}])
    , 5000

  off: (msg, cb) ->
    clearInterval(@interval)

  disconnect: ->

  onSelectionChange: (cb) -> cb()

RESPONSES =
  'bindings':
    elements: {
      1: {
        node: {id: 'id', className: '', type: 'div'}
        context: {foo: 'bar', show: true, other: 'test'}
        bindings: [{type: 'bind', definition: 'foo', value: 'bar'},
                   {type: 'bind-show', definition: 'show', value: true}]
      },
      2: {
        node: {id: '', className: 'class', type: 'input'}
        context: {foo: 'bar', show: true, other: 'test'}
        bindings: [{type: 'bind', definition: 'other', value: 'test'},
                   {type: 'bind-show', definition: 'show', value: true}]
      }
    }

  'context':
    context: {foo: 'bar'}

  'current-context':
    context: {a: 'b'}
    keypath: 'inner'