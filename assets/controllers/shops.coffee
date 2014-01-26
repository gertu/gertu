ShopFunctions = (() ->

  _getSignUpValidationErrors = ($scope) ->

    validationErrors = []

    # Verify password and passwordRpt match
    if $scope.password != $scope.passwordRpt
      validationErrors.push('PASSWORDS_DO_NOT_MATCH')

    if !$scope.shopname
      validationErrors.push('SHOP_NAME_HAS_TO_BE_PROVIDED')

    if !$scope.email
      validationErrors.push('EMAIL_HAS_TO_BE_PROVIDED')

    if !$scope.password
      validationErrors.push('PASSWORD_HAS_TO_BE_PROVIDED')

    validationErrors

  _existsEmailForShopInDatabase = ($http, emailAccount, callbackFn) ->

    existsEmail = true

    $http(
      url: "/api/v1/shop/emailexists?email=" + emailAccount
      method: "GET"
    )
    .success (data) ->
      existsEmail = false unless data == 'True'
      callbackFn(existsEmail)
    .error () ->
      existsEmail = false
      callbackFn(existsEmail)

    @

  getSignUpValidationErrors: _getSignUpValidationErrors
  existsEmailForShopInDatabase: _existsEmailForShopInDatabase
)()

# Shop SignUp
angular.module("mean.shops").controller "ShopSignUpController",
  ["$scope", "$http", "$location", "Global", ($scope, $http, $location, Global) ->

    $scope.global = Global
    $scope.errors = null

    $scope.doSignUp = () ->

      validationErrors = ShopFunctions.getSignUpValidationErrors($scope)

      ShopFunctions.existsEmailForShopInDatabase($http, $scope.email, (result) ->
        if result
          validationErrors.push('EMAIL_ALREADY_EXISTS')

        if validationErrors.length > 0
          $scope.errors = validationErrors
        else
          $http(
            url: "/api/v1/shop/signup"
            method: "POST"
            data:
              name: $scope.shopname
              email: $scope.email
              password: $scope.password
          )
          .success () ->
            $scope.global.authenticated = true
            $scope.global.shop = {name: $scope.shopname, email: $scope.email }
            
            $location.path('/')
          .error (errorData) ->
              $scope.errorMsg = errorData
      )


  ]

# Shop LogIn
angular.module("mean.shops").controller "ShopLogInController",
  ["$scope", "$location", "$http", "Global", ($scope, $location, $http, Global) ->

    $scope.global = Global
    $scope.errorMsg = undefined

    $scope.doLogIn = () ->
      
      # Verify password and email have been provided
      if $scope.email? and $scope.password? and $scope.email != '' and $scope.password != ''

        $http(
          url: "/api/v1/shop/login"
          method: "POST"
          data:
            email: $scope.email
            password: $scope.password
        )
        .success (data, status) ->
          $scope.global.authenticated = true
          $scope.global.shop = data

          console.log $scope.global

          $location.path('/')

        .error (data, status) ->
          if status == 403
            $scope.errorMsg = 'NO_SHOP_HAS_BEEN_FOUND'

      else if (not $scope.password? or $scope.password == '') and (not $scope.email? or $scope.email == '')

        $scope.errorMsg = 'PASSWORD_AND_EMAIL_HAVE_TO_BE_PROVIDED'

      else if not $scope.password? or $scope.password == '' then $scope.errorMsg = 'PASSWORD_HAS_TO_BE_PROVIDED'

      else if not $scope.email? or $scope.email == '' then $scope.errorMsg = 'EMAIL_HAS_TO_BE_PROVIDED'

      else $scope.errorMsg = 'PASSWORD_AND_EMAIL_HAVE_TO_BE_PROVIDED'
  ]