spawn  = require('child_process').spawn

coffeeCompile = (dest, src, flags) ->
  spawn('coffee', [flags, '-o', dest, src])

task 'build', 'compile the extension', ->
  coffeeCompile('./dist', './src', '-c')

task 'watch', 'watches and compiles coffee', ->
  coffeeCompile('./dist', './src', '-cw')
