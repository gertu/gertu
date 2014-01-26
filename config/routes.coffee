async = require "async"
users = require "../server/controllers/user"
index = require "../server/controllers/index"
Security = require "../server/tools/security"

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
  app.get    "/api/deals", deals.all
  app.get    "/api/deals/:dealId", deals.show
  app.post   "/api/deals", deals.create
  app.put    "/api/deals/:dealId", deals.update
  app.delete "/api/deals/:dealId", deals.destroy
  #Finish with setting up the articleId param
  app.param 'dealId', deals.deal

  # Management routes

  # Access routes
  managementAccess = require("../server/controllers/management/access")

  app.get  "/management/access/login", managementAccess.login
  app.post "/management/access/login", managementAccess.loginDo
  app.get "/management/access/logout", managementAccess.logout
  # End of access routes

  managementDashboard = require("../server/controllers/management/dashboard")
  app.get  "/management/dashboard", Security.authenticateAdministrator, managementDashboard.show

  # Deal categories
  managementDealCategories = require("../server/controllers/management/dealCategories")
  app.get  "/management/deal-categories/list", Security.authenticateAdministrator, managementDealCategories.list
  app.get  "/management/deal-categories/edit/0", Security.authenticateAdministrator, managementDealCategories.add
  app.get  "/management/deal-categories/edit/:id", Security.authenticateAdministrator, managementDealCategories.edit
  app.post "/management/deal-categories/edit/:id", Security.authenticateAdministrator, managementDealCategories.editDo
  app.get  "/management/deal-categories/remove/:id", Security.authenticateAdministrator, managementDealCategories.remove
  app.post "/management/deal-categories/remove/:id", Security.authenticateAdministrator, managementDealCategories.removeDo
  # End of deal categories

  # Currency management
  managementCurrencies = require("../server/controllers/management/currencies")
  app.get  "/management/currencies/list", Security.authenticateAdministrator, managementCurrencies.list
  app.get  "/management/currencies/edit/0", Security.authenticateAdministrator, managementCurrencies.add
  app.get  "/management/currencies/edit/:id", Security.authenticateAdministrator, managementCurrencies.edit
  app.post "/management/currencies/edit/:id", Security.authenticateAdministrator, managementCurrencies.editDo
  app.get  "/management/currencies/remove/:id", Security.authenticateAdministrator, managementCurrencies.remove
  app.post "/management/currencies/remove/:id", Security.authenticateAdministrator, managementCurrencies.removeDo
  app.get  "/management/currencies/loadRates", Security.authenticateAdministrator, managementCurrencies.loadRates
  # End of currency management

  # Adminstrator management
  managementAdministrators = require("../server/controllers/management/administrators")
  app.get  "/management/administrators/list", Security.authenticateAdministrator, managementAdministrators.list
  app.get  "/management/administrators/edit/0", Security.authenticateAdministrator, managementAdministrators.add
  app.get  "/management/administrators/edit/:id", Security.authenticateAdministrator, managementAdministrators.edit
  app.post "/management/administrators/edit/:id", Security.authenticateAdministrator, managementAdministrators.editDo
  app.get  "/management/administrators/remove/:id", Security.authenticateAdministrator, managementAdministrators.remove
  app.post "/management/administrators/remove/:id", Security.authenticateAdministrator, managementAdministrators.removeDo
  # End of adminstrator management

  # End of management routes

  # Home routes
  index = require("../server/controllers/index")

  app.get "/",  index.render
  app.get "/*", index.render
