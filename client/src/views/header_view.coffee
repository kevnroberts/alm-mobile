define ->
  Chaplin = require 'chaplin'
  hbs = require 'hbsTemplate'
  View = require 'views/base/view'

  class HeaderView extends View
    autoRender: true
    region: 'header'
    template: hbs['templates/header']

    listen:
      'updatetitle mediator': 'updateTitle'
      'loadedSettings mediator': 'render'
      'dispatcher:dispatch mediator': 'render'
      'navigation:show mediator': 'onNavigationShow'
      'navigation:hide mediator': 'onNavigationHide'

    events:
      'click div[data-target]': 'doNavigate'
      'swipe': 'gotSwiped'

    doNavigate: (e) ->
      page = e.currentTarget.getAttribute 'data-target'

      if page is 'back'
        window.history.back()
      else if page is 'navigation'
        @publishEvent 'navigation:show'
      else
        @publishEvent '!router:route', page
      e.preventDefault()


    gotSwiped: (e) ->
      console.log 'got swiped', e

    show: -> @$el.show() if @$el.is ':hidden'

    hide: -> @$el.hide() if @$el.is ':visible'

    makeButton: (target, icon, cls = "") ->
      """<div class="btn navbar-inverse #{cls}" data-target="#{target}"><i class="#{icon}"></i></div>"""

    getTemplateData: ->
      current_page = @_getCurrentPage()

      data =
        title: @title
        onNavigateScreen: @onNavigateScreen

      if current_page in ['/userstories', '/defects', '/tasks']
        data.left_button =  @makeButton 'navigation', 'icon-reorder', 'cyan'
        data.right_button = @makeButton 'settings', 'icon-cog'
      else if current_page is '/settings'
        data.left_button = @makeButton 'back', 'icon-arrow-left'
      else # if current_page in ['detail', 'column']
        data.left_button =  @makeButton 'back', 'icon-arrow-left'
        data.right_button = @makeButton 'settings', 'icon-cog'

      data

    updateTitle: (title) ->
      @title = title
      @render()

    onNavigationShow: ->
      @onNavigateScreen = true
      @render()

    onNavigationHide: ->
      @onNavigateScreen = false
      @render()

    _getCurrentPage: ->
      window.location.pathname
