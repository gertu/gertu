async = require "async"
users = require "../server/controllers/user"
index = require "../server/controllers/index"

module.exports = (app, passport) ->
  app.get "/signin",  users.signin
  app.get "/signup",  users.signup
  app.get "/signout", users.signout

  app.post "/users", users.create
  app.post "/users/session", passport.authenticate("local",
    failureRedirect: "/"
    failureFlash   : "Invalid email or password"
    successFlash   : "Welcome!"
  ), users.session

  app.get "/api/profile", users.me
  app.put "/api/profile/:profileId", users.update
  app.get "/users/:userId", users.show

  #Shop route
  shop = require("../server/controllers/shop")
  app.post "/shop/signup", shop.signup
  app.post "/shop/login", shop.login
  app.post "/shop/logoff", shop.logoff
  app.get "/shop/emailexists", shop.emailexists
  app.get "/shop/current", shop.current

  # Finish with setting up the userId param
  app.param "userId", users.user

  # Home route
  app.get "/",  index.render
  app.get "/*", index.render
