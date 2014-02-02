#Offers service used for offers REST endpoint
angular.module("mean.shops").factory "Shop", ["$resource", ($resource) ->
  $resource "/api/v1/shops/:shopId",
    shopId: "@_id",
]

angular.module("mean.shops").factory "Validation", ->
  newShop: (shopData) ->
    validationErrors = []

    # Verify password and passwordRpt match
    if shopData.password != shopData.passwordRpt
      validationErrors.push('PASSWORDS_DO_NOT_MATCH')

    if not shopData.name
      validationErrors.push('SHOP_NAME_HAS_TO_BE_PROVIDED')

    if not shopData.email
      validationErrors.push('EMAIL_HAS_TO_BE_PROVIDED')

    if not shopData.password
      validationErrors.push('PASSWORD_HAS_TO_BE_PROVIDED')

    validationErrors

  loginShop: (shopData) ->
    validationErrors = []

    if not shopData.email
      validationErrors.push('EMAIL_HAS_TO_BE_PROVIDED')

    if not shopData.password
      validationErrors.push('PASSWORD_HAS_TO_BE_PROVIDED')

    validationErrors

  emailExists: ($http, emailAccount, callbackFn) ->
    existsEmail = true

    $http(
      url: "/api/v1/shops/emailexists?email=" + emailAccount
      method: "GET"
    )
    .success (data) ->
      existsEmail = false unless data == 'True'
      callbackFn(existsEmail)
    .error () ->
      existsEmail = false
      callbackFn(existsEmail)

    @