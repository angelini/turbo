class Turbo.MockMessenger

  @connect: ->
    new Turbo.MockMessenger

  send: (msg, cb) ->
    cb(RESPONSES[msg.type])

  disconnect: ->

RESPONSES =
  'bindings':
    elements: [
      {
        node: {id: 'id', className: 'class', type: 'div'}
        context: {foo: 'bar'}
        bindings: [{type: 'bind', definition: 'foo'}]
      }
    ]

  'context':
    context: {foo: 'bar'}

  'current-context':
    context: {a: 'b'}
    keypath: 'inner'