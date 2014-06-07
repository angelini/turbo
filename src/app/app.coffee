log = (m...)->
  console.log(['[app]'].concat(m)...)


class Turbo.App

  @start: (messenger) ->
    Turbo.instance = new Turbo.App(messenger)
    Turbo.instance.navigate('bindings')

  @stop: ->
    Turbo.instance.messenger.disconnect()

  @log: log

  @sendMessage: (msg, cb) ->
    Turbo.instance.messenger.send(msg, cb)

  @on: (msg, cb) ->
    Turbo.instance.messenger.on(msg, cb)

  @off: (msg, cb) ->
    Turbo.instance.messenger.off(msg, cb)

  @onSelectionChange: (cb) ->
    Turbo.instance.messenger.onSelectionChange(cb)

  constructor: (@messenger) ->
    @$sidebar = $('.sidebar')
    @$content = $('.content')

    @initNav(@$sidebar)

  initNav: ($nav) ->
    $nav.on 'click', (event) =>
      event.preventDefault()

      section = $(event.target).data('section')
      @navigate(section)

  navigate: (section) ->
    $previous = @$sidebar.find('li.selected')
    $previous.removeClass('selected')
    @killPreviousSection($previous.data('section'))

    @$sidebar.find("li[data-section=\"#{section}\"]").addClass('selected')

    switch section
      when 'bindings' then Turbo.Bindings.init(@$content)
      when 'contexts' then Turbo.Contexts.init(@$content)

  killPreviousSection: (section) ->
    switch section
      when 'bindings' then Turbo.Bindings.die()