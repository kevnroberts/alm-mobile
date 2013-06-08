define ->
  hbs = require 'hbsTemplate'
  utils = require 'lib/utils'
  Artifacts = require 'collections/artifacts'
  View = require 'views/base/view'

  class NavigationView extends View
    autoRender: true
    region: 'navigation'
    template: hbs['navigation/templates/navigation']

    ENTER_KEY: 13

    listen:
      'navigation:show mediator': 'show'

    events:
      'click button[data-target]': 'doNavigate'
      'keydown .search-query': 'searchKeyDown'

    settings:
      workType: 'myWork'

    doNavigate: (e) ->
      @hide()

      currentRoute = window.location.pathname
      newRoute = e.currentTarget.getAttribute('data-target')

      unless newRoute == currentRoute || (newRoute == '' && _.contains(['/userstories', '/tasks', '/defects'], currentRoute))
        @publishEvent '!router:route', newRoute

    searchKeyDown: (event) ->
      switch event.which
        when @ENTER_KEY
          event.preventDefault()
          @doSearch event.target.value

    doSearch: (keyword) ->
      $('.search-no-results').remove()
      new Artifacts().fetch
        data:
          fetch: "ObjectID,Name"
          search: keyword
        success: (collection, response, options) =>
          if collection.length > 0
            @hide()
            firstResult = collection.first()
            @publishEvent '!router:route', utils.getDetailHash(firstResult)
          else
            @_noSearchResults()

    show: ->
      $('#page-container').attr('class', $('#page-container').attr('class').replace(/(\spage\stransition\scenter)?$/, ' page transition right'))
      @$el.parent().attr('class', @$el.parent().attr('class').replace(/(transition\s)?left/, 'transition center'))
      $('#mask').show()

    hide: ->
      @$el.parent().attr('class', @$el.parent().attr('class').replace(/center/, 'left'))
      $('#page-container').attr('class', $('#page-container').attr('class').replace(/right/, 'center'))
      $('#mask').hide()
      @publishEvent 'navigation:hide'


    getSetting: (setting) -> @settings[setting]

    getTemplateData: ->
      timeRemaining: 4
      timeRemainingUnits: 'Days'
      percentAccepted: 50
      pointsAccepted: 6
      totalPoints: 12
      activeDefects: 3
      buttons: [
        {
          displayName: if @getSetting('workType') is 'myWork' then 'My Work' else 'My Team'
          viewHash: ''
        }
        {
          displayName: 'Tracking Board'
          viewHash: 'board'
        }
        {
          displayName: 'Burndown Chart'
          viewHash: 'burndown'
        }
        {
          displayName: 'Recent Activity'
          viewHash: 'recentActivity'
        }
      ]

    _noSearchResults: ->
      alert = $('body').append([
        '<div class="search-no-results alert alert-error">',
        '<button type="button" class="close" data-dismiss="alert">&times;</button>',
        'No results matched your search.</div>'
      ].join '')
      noResults = $('.search-no-results')
      @_center(noResults)
      setTimeout(->
        noResults = $('.search-no-results')
        noResults.fadeOut(400, -> noResults.remove())
      , 1500)

    _center: (el) ->
      container = $(window)
      boundingRec = $('.search-query')[0].getBoundingClientRect()
      el.css('top': "#{boundingRec.top + boundingRec.height}px", 'left': "#{boundingRec.left}px")