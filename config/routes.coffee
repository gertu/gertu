async = require("async")
module.exports = (app, passport, auth) ->

  #Home route
  index = require("../server/controllers/index")
  app.get "/",  index.render
  app.get "/*", index.render