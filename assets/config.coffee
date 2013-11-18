#Setting up route
window.app.config ["$routeProvider", ($routeProvider) ->
  $routeProvider.when("/",
    templateUrl: "views/pages/home.html"

  ).otherwise redirectTo: "/"
]

#Setting HTML5 Location Mode
window.app.config ["$locationProvider", ($locationProvider) ->
  $locationProvider.html5Mode true
]