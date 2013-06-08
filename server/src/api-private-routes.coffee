Auth = require './auth'
LoginRoutes = require './routes/login'

module.exports = (app) ->
  
  app.post '/login',
    LoginRoutes.login
  
  app.get '/isLoggedIn', (req, res) ->
    res.json { loggedIn: !!req.session.jsessionid }

  app.get '/getSessionInfo',
    Auth.isUserLoggedIn
    LoginRoutes.getSessionInfo