class Turbo.MockMessenger

  @connect: ->
    new Turbo.MockMessenger

  send: (msg, cb) ->
    cb(RESPONSES[msg.type])

  disconnect: ->

  onSelectionChange: (cb) -> cb()

RESPONSES =
  'bindings':
    elements: [
      {
        node: {id: 'id', className: '', type: 'div'}
        context: {foo: 'bar', show: true, other: 'test'}
        bindings: [{type: 'bind', definition: 'foo'},
                   {type: 'bind-show', definition: 'show'}]
      },
      {
        node: {id: '', className: 'class', type: 'input'}
        context: {foo: 'bar', show: true, other: 'test'}
        bindings: [{type: 'bind', definition: 'other'},
                   {type: 'bind-show', definition: 'show'}]
      }
    ]

  'context':
    context: {foo: 'bar'}

  'current-context':
    context: {a: 'b'}
    keypath: 'inner'