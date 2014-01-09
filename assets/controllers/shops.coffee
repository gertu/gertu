PasswordsDoNotMatch = 'Las contraseñas suministradas no coinciden'
ShopNameHasToBeProvided = 'Debe proporcionar un nombre para el comercio'
EmailHasToBeProvided = 'Debe proporcionar un email para el comercio'
PasswordHasToBeProvided = 'Debe proporcionar una contraseña para el comercio'
EmailAlreadyExists = 'Ya existe un comercio con ese email. Por favor, proporcione otro.'
NoShopHasBeenFound = 'No se ha encontrado ningún comercio con los credenciales suministrados'
PasswordAndEmailHaveToBeProvided = 'Debe indicar una contaseña y un email para poder acceder'

ShopFunctions = (() ->

  _getSignUpValidationErrors = ($scope) ->

    validationErrors = []

    # Verify password and passwordRpt match
    if $scope.password != $scope.passwordRpt
      validationErrors.push(PasswordsDoNotMatch)

    if !$scope.shopname
      validationErrors.push(ShopNameHasToBeProvided)

    if !$scope.email
      validationErrors.push(EmailHasToBeProvided)

    if !$scope.password
      validationErrors.push(PasswordHasToBeProvided)

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
          validationErrors.push(EmailAlreadyExists)

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
            $scope.errorMsg = NoShopHasBeenFound

      else if (not $scope.password? or $scope.password == '') and (not $scope.email? or $scope.email == '')

        $scope.errorMsg = PasswordAndEmailHaveToBeProvided

      else if not $scope.password? or $scope.password == '' then $scope.errorMsg = PasswordHasToBeProvided

      else if not $scope.email? or $scope.email == '' then $scope.errorMsg = EmailHasToBeProvided

      else $scope.errorMsg = PasswordAndEmailHaveToBeProvided
  ]

# Shop LogOut
angular.module("mean.shops").controller "ShopLogOutController",
  ["$scope", "$location", "$http", "Global", ($scope, $location, $http, Global) ->

    $http(
      url: "/api/v1/shop/logout"
      method: "POST"
      data:
        email: $scope.email
        password: $scope.password
    )
    .success (data, status) ->
      $scope.global.authenticated = false
      $scope.global.shop = null

    $location.path('/')
    
  ]
