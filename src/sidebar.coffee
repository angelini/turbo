class Turbo.Sidebar
  init: ->
    chrome.devtools.panels.elements.createSidebarPane 'Turbo', (sidebar) =>
      @update(sidebar)
      chrome.devtools.panels.elements.onSelectionChanged.addListener =>
        @update(sidebar)

  update: (sidebar) ->
    fnDef = @info.toString()
    sidebar.setExpression '(' + fnDef + ')()'

  info: ->
    try
      context = Bindings.context($0)
    catch e
