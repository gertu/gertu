async = require("async")
users = require("../server/controllers/user")

module.exports = (app, passport) ->
  app.get "/signin", users.signin

  app.post "/users/session", passport.authenticate("local",
    failureRedirect: "/signin"
    failureFlash   : "Invalid email or password"
    successFlash   : "Welcome!"
  ), users.session

  # Home route
  index = require("../server/controllers/index")
  app.get "/",  index.render
  app.get "/*", index.render