async = require "async"
users = require "../server/controllers/user"
index = require "../server/controllers/index"

module.exports = (app, passport) ->

  currentApiVersion = '/api/v1'

  app.get "/signin",  users.signin
  app.get "/signup",  users.signup
  app.get currentApiVersion + "/signout", users.signout

  app.post currentApiVersion + "/users", users.create
  app.post currentApiVersion + "/users/session", passport.authenticate("local",
    failureRedirect: "/"
    failureFlash   : "Invalid email or password"
    successFlash   : "Welcome!"
  ), users.session

  app.get currentApiVersion + "/profile", users.me
  app.put currentApiVersion + "/profile/:profileId", users.update
  app.get "/users/:userId", users.show

  # Shop routes
  shop = require("../server/controllers/shop")
  app.post currentApiVersion + "/shop/signup", shop.signup
  app.post currentApiVersion + "/shop/login", shop.login
  app.get "/shop/logout", shop.logout
  app.get  currentApiVersion + "/shop/emailexists", shop.emailexists
  app.get  currentApiVersion + "/shop/current", shop.current

  # Finish with setting up the userId param
  app.param "userId", users.user

  #Deal routes
  deals = require("../server/controllers/deals")
  app.get    currentApiVersion + "/deals", deals.all
  app.get    currentApiVersion + "/admin/deals/:shopId", deals.findByShop
  app.get    currentApiVersion + "/deals/:dealId", deals.show
  app.post   currentApiVersion + "/deals", deals.create
  app.put    currentApiVersion + "/deals/:dealId", deals.update
  app.delete currentApiVersion + "/deals/:dealId", deals.destroy
  #Finish with setting up the articleId param
  app.param 'dealId', deals.deal
  app.param 'shopId', deals.shop

  dealscategory = require("../server/controllers/dealsCategory")
  app.get    currentApiVersion + "/dealscategory", dealscategory.all

  # Management routes

  # Access routes
  managementAccess = require("../server/controllers/management/access")

  app.get  "/management/access/login", managementAccess.login
  app.post "/management/access/login", managementAccess.loginDo
  app.get "/management/access/logout", managementAccess.logout
  # End of access routes

  managementDashboard = require("../server/controllers/management/dashboard")
  app.get  "/management/dashboard", managementDashboard.show

  # Deal categories
  managementDealCategories = require("../server/controllers/management/dealCategories")
  app.get  "/management/deal-categories/list", managementDealCategories.list
  app.get  "/management/deal-categories/edit/0", managementDealCategories.add
  app.get  "/management/deal-categories/edit/:id", managementDealCategories.edit
  app.post "/management/deal-categories/edit/:id", managementDealCategories.editDo
  app.get  "/management/deal-categories/remove/:id", managementDealCategories.remove
  app.post "/management/deal-categories/remove/:id", managementDealCategories.removeDo
  # End of deal categories

  # Currency management
  managementCurrencies = require("../server/controllers/management/currencies")
  app.get  "/management/currencies/list", managementCurrencies.list
  app.get  "/management/currencies/edit/0", managementCurrencies.add
  app.get  "/management/currencies/edit/:id", managementCurrencies.edit
  app.post "/management/currencies/edit/:id", managementCurrencies.editDo
  app.get  "/management/currencies/remove/:id", managementCurrencies.remove
  app.post "/management/currencies/remove/:id", managementCurrencies.removeDo
  app.get  "/management/currencies/loadRates", managementCurrencies.loadRates
  # End of currency management

  # End of management routes

  # Home routes
  index = require("../server/controllers/index")

  app.get "/",  index.render
  app.get "/*", index.render
