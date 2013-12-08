#Setting up route
window.app.config ["$routeProvider", ($routeProvider) ->
  $routeProvider
  .when("/", templateUrl: "views/pages/home.html")
  .when("/shop/signup", templateUrl: "/views/pages/shop/signup.html", controller: "ShopSignUpController")
  .when("/shop/login", templateUrl: "/views/pages/shop/login.html", controller: "ShopLogInController")
  .when("/shop/offers", templateUrl: "/views/pages/shop/offers.html", controller: "ShopOffersController")
  .otherwise redirectTo: "/"
]

#Setting HTML5 Location Mode
window.app.config ["$locationProvider", ($locationProvider) ->
  $locationProvider.html5Mode true
]