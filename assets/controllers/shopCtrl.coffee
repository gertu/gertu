# Shop SignUp
angular.module("mean.system").controller "ShopSignUpController",
  ["$scope", "$http", "$location", "Global", ($scope, $http, $location, Global) ->
    $scope.global = Global
    $scope.errors = null

    $scope.doSignUp = () =>

      validationErrors = []

      # Verify password and passwordRpt match
      if $scope.password == $scope.passwordRpt
        validationErrors.push('Passwords do not match')

      if !!$scope.shopname
        validationErrors.push('A shop name has to be provided')

      if !!$scope.email
        validationErrors.push('An email has to be provided')

      if !!$scope.password
        validationErrors.push('A password has to be provided')



      $http(
        url: "/api/shop/signup"
        method: "POST"
        data:
          name: $scope.shopname
          email: $scope.email
          password: $scope.password
      )
      .success (data, status, headers, config) ->

          $location.path('/shop/offers')

      .error (data, status, headers, config) ->

          $scope.errorMsg = data
  ]

# Shop LogIn
angular.module("mean.system").controller "ShopLogInController",
  ["$scope", "$location", "$http", "Global", ($scope, $location, $http, Global) ->

    $scope.global = Global
    $scope.errorMsg = ''

    $scope.doLogIn = () =>

      # Verify password and passwordRpt match
      if $scope.email != '' and $scope.password != ''

        $http(
          url: "/api/shop/login"
          method: "POST"
          data:
            email: $scope.email
            password: $scope.password
        )
        .success (data, status, headers, config) ->

          if status == 403
            $scope.errorMsg = 'No shop with that information has been found'
          else
            $location.path('/shop/offers/')

        .error (data, status, headers, config) ->
            $scope.errorMsg = data

      else
        $scope.errorMsg = 'Email and password must be provided'
  ]

# Shop offer list
angular.module("mean.system").controller "ShopOffersController",
  ["$scope", "Global", ($scope,Global) ->
    $scope.global = Global
    $scope.title = 'Offers for the shop'

  ]