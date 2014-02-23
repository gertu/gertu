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

  app.get  currentApiVersion + "/profile", users.me
  app.put  currentApiVersion + "/profile/:profileId", users.update
  app.post currentApiVersion + "/profile/updatepicture", users.updatePicture
  app.get  currentApiVersion + "/users/:userId", users.show

  # Shop routes
  shop = require("../server/controllers/shop")
  app.post currentApiVersion + "/shops", shop.signup
  app.post currentApiVersion + "/shops/login", shop.login
  app.get "/shop/logout", shop.logout
  app.get "/admin/confirmaccount/:accountid", shop.confirmAccount
  app.post currentApiVersion + "/shops/confirmaccount", shop.resendConfirmationAccount
  app.get  currentApiVersion + "/shops/emailexists", shop.emailexists
  app.get  currentApiVersion + "/shops", shop.current
  app.get  currentApiVersion + "/shopsinfo", shop.currentShopInfo
  app.post currentApiVersion + "/shopsinfo", shop.updateShopInfo

  # Finish with setting up the userId param
  app.param "userId", users.user

  #Deal routes
  deals = require("../server/controllers/deals")
  app.get    currentApiVersion + "/deals", deals.all
  app.get    currentApiVersion + "/admin/deals/:shopId", deals.findByShop
  app.get    currentApiVersion + "/deals/:dealId", deals.show
  app.post   currentApiVersion + "/deals", deals.create
  app.post   currentApiVersion + "/admin/photo", deals.updatephoto
  app.put    currentApiVersion + "/deals/:dealId", deals.update
  app.delete currentApiVersion + "/deals/:dealId", deals.destroy
  # Reserves routes
  reservations = require "../server/controllers/reservations"
  app.post   currentApiVersion + "/deals/:dealId/reserve", reservations.reserve

  app.get    currentApiVersion + "/myreserves/:userId", reservations.myReserves
  app.get    currentApiVersion + "/mybuys/:userId", reservations.myBuys
  # Comments routes
  app.put    currentApiVersion + "/deals/:dealId/addcomment", deals.addComment
  app.get    currentApiVersion + "/comments/:userId", deals.myComments


  #Finish with setting up the articleId param
  app.param 'shopId', deals.shop
  app.param 'dealId', deals.deal


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

  # Payment management
  managementPayments = require("../server/controllers/management/payments")
  app.get  "/management/payments/list", Security.authenticateAdministrator, managementPayments.list
  app.get  "/management/payments/confirm/:id", Security.authenticateAdministrator, managementPayments.confirm
  app.get  "/management/payments/history/:id", Security.authenticateAdministrator, managementPayments.history
  # End of payment management

  # Shop management
  managementShops = require("../server/controllers/management/shops")
  app.get  "/management/shops/list", Security.authenticateAdministrator, managementShops.list
  app.get  "/management/shops/view/:id", Security.authenticateAdministrator, managementShops.view
  # End of payment management

   # Shop management
  managementUsers = require("../server/controllers/management/users")
  app.get  "/management/users/list", Security.authenticateAdministrator, managementUsers.list
  app.get  "/management/users/view/:id", Security.authenticateAdministrator, managementUsers.view
  # End of payment management

  # End of management routes

  # Mobile API
  mobileApi = require "../server/controllers/mobileapi/mobileapi"
  currentMobileApiVersion = '/mobile/v1'

  app.post currentMobileApiVersion + "/users/session", mobileApi.usersLogin
  app.delete currentMobileApiVersion + "/users/session", Security.authenticateMobile, mobileApi.usersLogout

  app.get  currentMobileApiVersion + "/users", Security.authenticateMobile, mobileApi.usersGetCurrent
  app.post currentMobileApiVersion + "/users", mobileApi.usersSignUp
  app.put  currentMobileApiVersion + "/users", Security.authenticateMobile, mobileApi.usersUpdate

  app.get  currentMobileApiVersion + "/deals", mobileApi.dealsGetAll
  app.post currentMobileApiVersion + "/deals", Security.authenticateMobile, mobileApi.dealsGetAllByPositition
  app.get  currentMobileApiVersion + "/deals/:id", mobileApi.dealsGetById
  app.post  currentMobileApiVersion + "/deals/:id/reservation", Security.authenticateMobile, mobileApi.dealsMakeReservationById
  app.post currentMobileApiVersion + "/deals/:id/comment", Security.authenticateMobile, mobileApi.dealsAddComment
  app.get  currentMobileApiVersion + "/users/reservations", Security.authenticateMobile, mobileApi.reservationsGetAll

  # Shop management area
  shopManagementAccess = require("../server/controllers/shopmanagement/access")
  app.get  "/shopmanagement/login", shopManagementAccess.login
  app.post "/shopmanagement/login", shopManagementAccess.loginDo
  app.get  "/shopmanagement/logout", shopManagementAccess.logout
  app.get  "/shopmanagement/dashboard", Security.authenticateShop, shopManagementAccess.dashboard
  app.post "/shopmanagement/signup", shopManagementAccess.signupDo
  app.get  "/shopmanagement/confirm/:shopId", shopManagementAccess.confirm
  app.get  "/shopmanagement/resetpassword", shopManagementAccess.resetpassword
  app.post "/shopmanagement/resetpassword", shopManagementAccess.resetpasswordDo
  app.get  "/shopmanagement/termsandconditions", shopManagementAccess.termsandconditions

  shopManagementProfile = require("../server/controllers/shopmanagement/profile")
  app.get  "/shopmanagement/profile/view", Security.authenticateShop, shopManagementProfile.view
  app.post "/shopmanagement/profile/view", Security.authenticateShop, shopManagementProfile.viewDo

  shopManagementDeals = require("../server/controllers/shopmanagement/deals")
  app.get  "/shopmanagement/deals/list", Security.authenticateShop, shopManagementDeals.list
  app.get  "/shopmanagement/deals/new", Security.authenticateShop, shopManagementDeals.create
  app.post "/shopmanagement/deals/new", Security.authenticateShop, shopManagementDeals.createDo
  app.get  "/shopmanagement/deals/edit/:dealId", Security.authenticateShop, shopManagementDeals.edit
  app.post "/shopmanagement/deals/edit", Security.authenticateShop, shopManagementDeals.editDo
  app.get  "/shopmanagement/deals/delete/:dealId", Security.authenticateShop, shopManagementDeals.delete
  app.post "/shopmanagement/deals/delete", Security.authenticateShop, shopManagementDeals.deleteDo

  shopManagementComments = require("../server/controllers/shopmanagement/comments")
  app.get  "/shopmanagement/comments/list", Security.authenticateShop, shopManagementComments.list

  shopManagementReservations = require("../server/controllers/shopmanagement/reservations")
  app.get  "/shopmanagement/reservations/list", Security.authenticateShop, shopManagementReservations.list
  app.get  "/shopmanagement/reservations/confirm", Security.authenticateShop, shopManagementReservations.confirm
  app.post "/shopmanagement/reservations/confirm", Security.authenticateShop, shopManagementReservations.confirmDo

  shopManagementPayments = require("../server/controllers/shopmanagement/payments")
  app.get  "/shopmanagement/payments/list", Security.authenticateShop, shopManagementPayments.list
  # End of shop management area



  # Home routes
  index = require("../server/controllers/index")

  app.get "/",  index.render
  app.get currentApiVersion + "/webData", index.load
  app.get "/*", index.render
