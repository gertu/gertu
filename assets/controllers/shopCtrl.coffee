ShopFunctions = (() ->

  _getSignUpValidationErrors = ($scope) ->

    validationErrors = []

    # Verify password and passwordRpt match
    if $scope.password != $scope.passwordRpt
      validationErrors.push('Passwords do not match')

    if !$scope.shopname
      validationErrors.push('A shop name has to be provided')

    if !$scope.email
      validationErrors.push('An email has to be provided')

    if !$scope.password
      validationErrors.push('A password has to be provided')

    validationErrors

  _existsEmailForShopInDatabase = ($http, emailAccount) ->

    existsEmail = true

    $http(
      url: "/shop/emailexists"
      method: "POST"
      data:
        email: emailAccount
    )
    .success () ->
      existsEmail = true
    .error () ->
      existsEmail = false

    existsEmail

  getSignUpValidationErrors: _getSignUpValidationErrors
  existsEmailForShopInDatabase: _existsEmailForShopInDatabase
)()

# Shop SignUp
angular.module("mean.system").controller "ShopSignUpController",
  ["$scope", "$http", "$location", "Global", ($scope, $http, $location, Global) ->

    $scope.global = Global
    $scope.errors = null

    $scope.doSignUp = () ->

      validationErrors = ShopFunctions.getSignUpValidationErrors($scope)

      if ShopFunctions.existsEmailForShopInDatabase($http, $scope.email)
        validationErrors.push('Email already exists. Please do choose another one.')

      if validationErrors.length > 0
        $scope.errors = validationErrors
      else
        $http(
          url: "/shop/signup"
          method: "POST"
          data:
            name: $scope.shopname
            email: $scope.email
            password: $scope.password
        )
        .success () ->
          $location.path('/shop/offers')
        .error (errorData) ->
          $scope.errorMsg = errorData
  ]

# Shop LogIn
angular.module("mean.system").controller "ShopLogInController",
  ["$scope", "$location", "$http", "Global", ($scope, $location, $http, Global) ->

    $scope.global = Global
    $scope.errorMsg = ''

    $scope.doLogIn = () ->

      # Verify password and passwordRpt match
      if $scope.email != '' and $scope.password != ''

        $http(
          url: "/shop/login"
          method: "POST"
          data:
            email: $scope.email
            password: $scope.password
        )
        .success (data, status) ->

          if status == 403
            $scope.errorMsg = 'No shop with that information has been found'
          else
            $location.path('/shop/offers/')

        .error (data) ->
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