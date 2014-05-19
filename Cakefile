spawn  = require('child_process').spawn

coffeeCompile = (dest, src, watch) ->
  flags = if watch then '-cw' else '-c'
  coffee = spawn('coffee', [flags, '-o', dest, src])

  coffee.stdout.on 'data', (data) -> console.log('[coffee]', data.toString())
  coffee.stderr.on 'data', (data) -> console.error('[coffee]', data.toString())

sassCompile = (dest, src, watch) ->
  flag = if watch then '--watch' else '--update'
  sass = spawn('sass', [flag, "#{src}:#{dest}"])

  sass.stdout.on 'data', (data) -> console.log('[sass]', data.toString())
  sass.stderr.on 'data', (data) -> console.error('[sass]', data.toString())

task 'build', 'compile the extension', ->
  coffeeCompile('./dist', './src', false)
  sassCompile('./dist', './styles', false)

task 'watch', 'watches and compiles coffee', ->
  coffeeCompile('./dist', './src', true)
  sassCompile('./dist', './styles', true)
