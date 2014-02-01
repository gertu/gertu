angular.module('mean').config ["$translateProvider", ($translateProvider) ->
  $translateProvider.translations "en-US",
    HOME: "Home"
    PASSWORDS_DO_NOT_MATCH: 'EN_Las contraseñas suministradas no coinciden'
    SHOP_NAME_HAS_TO_BE_PROVIDED: 'EN_Debe proporcionar un nombre para el comercio'
    EMAIL_HAS_TO_BE_PROVIDED: 'EN_Debe proporcionar un email para el comercio'
    PASSWORD_HAS_TO_BE_PROVIDED: 'EN_Debe proporcionar una contraseña para el comercio'
    EMAIL_ALREADY_EXISTS: 'EN_Ya existe un comercio con ese email. Por favor, proporcione otro.'
    NO_SHOP_HAS_BEEN_FOUND: 'EN_No se ha encontrado ningún comercio con los credenciales suministrados'
    PASSWORD_AND_EMAIL_HAVE_TO_BE_PROVIDED: 'EN_Debe indicar una contaseña y un email para poder acceder'
    UNKNOWN_ERROR: 'EN_Error desconocido'
    # Here we must add translations for english language

  $translateProvider.translations "es-ES",
    HOME: "Inicio"
    PASSWORDS_DO_NOT_MATCH: 'Las contraseñas suministradas no coinciden'
    SHOP_NAME_HAS_TO_BE_PROVIDED: 'Debe proporcionar un nombre para el comercio'
    EMAIL_HAS_TO_BE_PROVIDED: 'Debe proporcionar un email para el comercio'
    PASSWORD_HAS_TO_BE_PROVIDED: 'Debe proporcionar una contraseña para el comercio'
    EMAIL_ALREADY_EXISTS: 'Ya existe un comercio con ese email. Por favor, proporcione otro.'
    NO_SHOP_HAS_BEEN_FOUND: 'No se ha encontrado ningún comercio con los credenciales suministrados'
    PASSWORD_AND_EMAIL_HAVE_TO_BE_PROVIDED: 'Debe indicar una contaseña y un email para poder acceder'
    UNKNOWN_ERROR: 'Error desconocido'
    # Here we must add translations for spanish language


  $translateProvider.preferredLanguage (if navigator.language is "es" then "es-ES" else navigator.language)
]