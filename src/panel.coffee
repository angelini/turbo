class Turbo.Panel
  init: ->
    chrome.devtools.panels.create 'Turbo', 'img/logo.png', 'views/panel.html', ->
