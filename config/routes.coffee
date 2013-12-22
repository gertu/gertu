async = require("async")
module.exports = (app) ->

  #Shop route
  shop = require("../server/controllers/shop")
  app.post "/shop/signup", shop.signup
  app.post "/shop/login", shop.login
  app.post "/shop/logoff", shop.logoff
  app.post "/shop/emailexists", shop.emailexists

  #Home route
  index = require("../server/controllers/index")
  app.get "/",  index.render
  app.get "/*", index.render

