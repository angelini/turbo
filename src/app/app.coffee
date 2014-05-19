log = (m...)->
  console.log(['[app]'].concat(m)...)

class Turbo.App

  @start: ->
    messenger = Turbo.Messenger.connect()
    Turbo.instance = new Turbo.App(messenger)
    Turbo.instance.navigate('bindings')

  @stop: ->
    Turbo.instance.messenger.disconnect()

  @log: log

  @sendMessage: (msg, cb) ->
    Turbo.instance.sendMessage(msg, cb)

  constructor: (@messenger) ->
    @$sidebar = $('.sidebar')
    @$content = $('.content')

    @initNav(@$sidebar)

  initNav: ($nav) ->
    $nav.on 'click', (event) =>
      event.preventDefault()

      section = $(event.target).parent().data('section')
      @navigate(section)

  navigate: (section) ->
    @$sidebar.find('li.active').removeClass('active')
    @$sidebar.find("li[data-section=\"#{section}\"]").addClass('active')

    switch section
      when 'bindings' then Turbo.Bindings.init(@$content)
      when 'contexts' then Turbo.Contexts.init(@$content)

  sendMessage: (msg, cb) ->
    @messenger.send(msg, cb)
