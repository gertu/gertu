#Setting up route
angular.module('mean').config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when('/deals',
    templateUrl: '/views/deals/list.html'

  ).when('/deals/:dealId',
    templateUrl: '/views/deals/view.html'

  ).when('/profile',
    templateUrl: '/views/users/profile.html'

  ).when('/profile/edit',
    templateUrl: '/views/users/edit.html'

  ).when('/about',
    templateUrl: '/views/pages/about.html'

  ).when('/contact',
    templateUrl: '/views/pages/contact.html'

  ).when('/',
    templateUrl: '/views/pages/home.html'

  ).when('/404',
    templateUrl: '/views/404.html'
  
  ).when("/admin/signup",
    templateUrl: "/views/pages/shop/signup.html",
    controller: "ShopSignUpController"

  ).when("/admin/login",
    templateUrl: "/views/pages/shop/login.html",
    controller: "ShopLogInController"

  ).when('/admin/deals/create',
    templateUrl: '/views/pages/shop/create.html'

  ).when("/admin/deals/:shopId",
    templateUrl: "/views/pages/shop/deals.html"

  ).when('/admin/deals/:dealId',
    templateUrl: '/views/pages/shop/view.html'

  ).when('/admin/deals/edit/:dealId',
    templateUrl: '/views/pages/shop/edit.html'

  ).otherwise redirectTo: '/404'
]

#Setting HTML5 Location Mode
angular.module('mean').config ['$locationProvider', ($locationProvider) ->
  $locationProvider.html5Mode true
]