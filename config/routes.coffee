async = require "async"
users = require "../server/controllers/user"

module.exports = (app, passport) ->
  app.get "/signin",  users.signin
  app.get "/signup",  users.signup
  app.get "/signout", users.signout

  app.post "/users", users.create
  app.post "/users/session", passport.authenticate("local",
    failureRedirect: "/signin"
    failureFlash   : "Invalid email or password"
    successFlash   : "Welcome!"
  ), users.session

  app.get "/api/profile", users.me
  app.put "/api/profile/:profileId", users.update
  app.get "/users/:userId", users.show

  # Finish with setting up the userId param
  app.param "userId", users.user

  # Home route
  index = require("../server/controllers/index")
  app.get "/",  index.render
  app.get "/*", index.render
