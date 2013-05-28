define [
  'application'
  'views/view'
  'views/home/user_stories_view'
  'views/home/defects_view'
  'views/home/tasks_view'
  'models/user_story_collection'
  'models/defect_collection'
  'models/task_collection'
], (app, View, UserStoriesView, DefectsView, TasksView, UserStoryCollection, DefectCollection, TaskCollection) ->
  class HomeView extends View

    template: JST['home/templates/home']
    events:
      'click .btn-block': 'onButton'
      'click .nav a' : 'toggleActive'
      'click #add-artifact' : 'addArtifact'

    initialize: (options) ->
      super

      @error = false

      @userStories = new UserStoryCollection()
      @defects = new DefectCollection()
      @tasks = new TaskCollection()

      @currentTab = "userstory"

      Backbone.on "projectready", @updateTitle, this

      @

    updateTitle: (title) ->
      Backbone.trigger "updatetitle", title


    afterRender: ->
      unless @loaded
        setTimeout =>
          @load()
        , 1

    remove: ->
      super
      @loaded = false

    load: ->
      @loaded = true

      @updateTitle app.session.getProjectName()

      $("##{@currentTab}-tab").addClass('active')
      $("##{@currentTab}-view").addClass('active')

      @userStoriesView = new UserStoriesView
        model: @userStories

      @tasksView = new TasksView
        model: @tasks

      @defectsView = new DefectsView
        model: @defects

      @fetchUserStories()
      @fetchTasks()
      @fetchDefects()

    fetchUserStories: ->
      @userStories.fetch({
        data:
          fetch: ['ObjectID', 'FormattedID', 'Name', 'Ready', 'Blocked'].join ','
        success: (collection, response, options) =>
          @userStoriesView.render()
        failure: (collection, xhr, options) =>
          @error = true
      })

    fetchTasks: ->
      @tasks.fetch({
        data:
          fetch: ['ObjectID', 'FormattedID', 'Name', 'Ready', 'Blocked', 'ToDo'].join ','
        success: (collection, response, options) =>
          @tasksView.render()
        failure: (collection, xhr, options) =>
          @error = true
      })

    fetchDefects: ->
      @defects.fetch({
        data:
          fetch: ['ObjectID', 'FormattedID', 'Name'].join ','
        success: (collection, response, options) =>
          @defectsView.render()
        failure: (collection, xhr, options) =>
          @error = true
      })

    onButton: (event) ->
      url = event.currentTarget.id
      app.router.navigate url, {trigger: true}

    toggleActive: (event) ->
      @currentTab = event.currentTarget.id

    addArtifact: (event) ->
      app.router.navigate "new/#{@currentTab}", {trigger: true}