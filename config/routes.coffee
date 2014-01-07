async = require("async")
module.exports = (app) ->

  # Shop routes
  shop = require("../server/controllers/shop")
  app.post "/shop/signup", shop.signup
  app.post "/shop/login", shop.login
  app.post "/shop/logoff", shop.logoff
  app.get  "/shop/emailexists", shop.emailexists
  app.get  "/shop/current", shop.current

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

