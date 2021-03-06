define ->
  Chaplin = require 'chaplin'
  app = require 'application'
  Controller = require 'controllers/base/controller'
  Preference = require 'models/preference'
  LabsNoticeView = require 'views/auth/labs_notice'
  LoginView = require 'views/auth/login'

  class AuthController extends Controller

    logout: (params) ->
      app.session.logout()
      @login()

    login: (params) ->
      @view = @renderReactComponent LoginView
      @listenTo @view, 'submit', @onSubmit

    labsNotice: (params) ->
      @view = @renderReactComponent LabsNoticeView
      @listenTo @view, 'accept', @onAccept
      @listenTo @view, 'reject', @onReject

    onSubmit: (username, password, rememberme) ->
      app.session.authenticate username, password, (authenticated) =>
        if err?
          app.session.logout()
          @view.showError 'There was an error signing in. Please try again.'
        else
          if authenticated
            @redirectTo app.afterLogin, replace: true
          else
            app.session.logout()
            @view.showError 'The password you have entered is incorrect.'

    onAccept: ->
      app.session.acceptLabsNotice().then =>
        @redirectTo app.afterLogin, replace: true

    onReject: ->
      @redirectToRoute 'auth#login'
