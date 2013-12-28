async = require('async')
module.exports = (app, passport, auth) ->

  deals = require("../server/controllers/deals")
  app.get "/api/deals", deals.all
  app.get "/api/deals/:dealId", deals.show
  app.post "/api/deals", deals.create

  #Finish with setting up the articleId param
  app.param 'dealId', deals.deal


  #User Routes
  users = require("../server/controllers/users")
  app.get "/signin", users.signin
  app.get "/signup", users.signup
  app.get "/signout", users.signout

  #Setting up the users api
  app.post "/users", users.create
  app.post "/users/session", passport.authenticate("local",
    failureRedirect: "/"
    failureFlash: "Invalid email or password."
  ), users.session
  app.get "/api/profile", users.me
  app.put "/api/profile/:profileId", users.update
  app.get "/users/:userId", users.show

  #Finish with setting up the userId param
  app.param "userId", users.user

  #Home route
  index = require('../server/controllers/index')
  app.get '/', index.render
  app.get '/*', index.render