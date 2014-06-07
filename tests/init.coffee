window.assert = chai.assert;

mocha.checkLeaks();
mocha.globals(['jQuery', '_', 'chai', 'sinon', 'CoffeeScript', 'Turbo']);

mocha.run();