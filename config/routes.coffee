async = require("async")
users = require("../server/controllers/user")

module.exports = (app, passport, auth) ->
  # User route
  app.get "/signin", users.signin

  app.post "/users/session", passport.authenticate("local",
    failureRedirect: "/signin"
    failureFlash   : "Invalid email or password"
    successFlash   : "Welcome!"
  ), users.session

  app.get "/users/me",     users.me
  app.get "/users/:email", users.show


  # Home route
  index = require("../server/controllers/index")
  app.get "/",  index.render
  app.get "/*", index.render