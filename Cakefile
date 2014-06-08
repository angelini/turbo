spawn  = require('child_process').spawn

log = (prefix, data, fn = 'log') ->
  lines = data.split('\n')
  for line in lines
    console[fn](prefix, line) if line

coffeeCompile = (dest, src, watch) ->
  flags = if watch then '-cmw' else '-cm'
  coffee = spawn('coffee', [flags, '-o', dest, src])

  coffee.stdout.on 'data', (data) -> log('[coffee]', data.toString())
  coffee.stderr.on 'data', (data) -> log('[coffee]', data.toString(), 'error')

sassCompile = (dest, src, watch) ->
  flag = if watch then '--watch' else '--update'
  sass = spawn('sass', [flag, "#{src}:#{dest}"])

  sass.stdout.on 'data', (data) -> log('[sass]', data.toString())
  sass.stderr.on 'data', (data) -> log('[sass]', data.toString(), 'error')

task 'build', 'compile the extension', ->
  coffeeCompile('./dist', './src', false)
  coffeeCompile('./dist/tests', './tests', false)
  sassCompile('./dist', './styles', false)

task 'watch', 'watches and compiles the extension', ->
  coffeeCompile('./dist', './src', true)
  coffeeCompile('./dist/tests', './tests', true)
  sassCompile('./dist', './styles', true)
