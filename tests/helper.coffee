window.assert = chai.assert;
window.chrome = {runtime: {connect: ->}}

sourceMapSupport.install()

sandbox = null

setup ->
  sandbox = sinon.sandbox.create
    injectInto: @test.ctx
    properties: ['spy', 'stub', 'mock', 'clock']
    useFakeTime: true
    useFakeServer: false

teardown ->
  sandbox.verifyAndRestore()
  $('#fixtures').empty()

mocha.checkLeaks();
mocha.globals(['jQuery', '_', 'chai', 'sinon', 'CoffeeScript', 'Turbo']);

mocha.run();