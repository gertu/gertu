# Shop SignUp
angular.module("mean.shops").controller 'ShopSignUpController',
  ['$scope', '$http', '$location', 'Global', 'Shop', 'Validation',
  ($scope, $http, $location, Global, Shop, Validation) ->

    $scope.global = Global
    $scope.errors = null

    $scope.doSignUp = () ->

      validationErrors = Validation.newShop
        name: $scope.shopname
        email: $scope.email
        password: $scope.password
        passwordRpt: $scope.passwordRpt

      Validation.emailExists($http, $scope.email, (result) ->
        if result
          validationErrors.push('EMAIL_ALREADY_EXISTS')

        if validationErrors.length > 0
          $scope.errors = validationErrors
        else
          shop = new Shop(
            name: $scope.shopname,
            email: $scope.email,
            password: $scope.password
            )

          shop.$save(
            (successData) ->
              $scope.global.authenticated = true
              $scope.global.shop = successData
              $location.path('/')
            ,
            (errorData) ->
              $scope.errorMsg = errorData
            )
      )
  ]

# Shop LogIn
angular.module("mean.shops").controller "ShopLogInController",
  ["$scope", "$location", "$http", "Global", "Validation", ($scope, $location, $http, Global, Validation) ->

    $scope.global = Global
    $scope.errors = []

    $scope.doLogIn = () ->

      validationErrors = Validation.loginShop
        email: $scope.email
        password: $scope.password

      # Verify password and email have been provided
      if validationErrors.length == 0

        $http(
          url: "/api/v1/shops/login"
          method: "POST"
          data:
            email: $scope.email
            password: $scope.password
        )
        .success (data, status) ->
          $scope.global.authenticated = true
          $scope.global.shop = data

          $location.path('/')

        .error (data, status) ->
          $scope.errors = (if (status is 403) then ["NO_SHOP_HAS_BEEN_FOUND"] else ["UNKNOWN_ERROR"])

      else
        $scope.errors = validationErrors
  ]

# Shop LogIn
angular.module("mean.shops").controller "ShopProfileController",
  ["$scope", "$location", "$http", "Global", "Validation", "AppAlert"
  ($scope, $location, $http, Global, Validation, AppAlert) ->
  
    $http(
      url: "/api/v1/shopsinfo"
      method: "GET"
    )
    .success (data, status) ->
      $scope.shop = data
      $scope.center = new google.maps.LatLng(data.loc.latitude, data.loc.longitude)
    
    .error (data, status) ->
      $scope.errors = (if (status is 403) then ["NO_SHOP_HAS_BEEN_FOUND"] else ["UNKNOWN_ERROR"])
    
    $scope.$watch "center", (center) ->
      if center
        $scope.shop.loc.latitude  = center.lat()
        $scope.shop.loc.longitude = center.lng()
      return

    $scope.updateCenter = (lng, lat) ->
      $scope.center = new google.maps.LatLng(lat, lng)
      return

    $scope.updateShopInfo = () ->
      
      hasErrors = false

      if $scope.password? and $scope.passwordRpt?
        if $scope.password == $scope.passwordRpt
          $scope.shop.password = $scope.password
        else
          hasErrors = true
          AppAlert.add "warning","PASSWODRDS_DO_NOT_MATCH"
      else
        $scope.shop.password = ''

      if not hasErrors
        $http(
          url: "/api/v1/shopsinfo"
          method: "POST",
          data: $scope.shop
        )
        .success (data, status) ->
          $scope.shop = data
          AppAlert.add "success","INFORMATION_UPDATED"
        .error (data, status) ->
          $scope.errors = (if (status is 403) then ["NO_SHOP_HAS_BEEN_FOUND"] else ["UNKNOWN_ERROR"])
          AppAlert.add "warning","ERROR"
  ]