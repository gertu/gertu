angular.module('mean').config ["$translateProvider", ($translateProvider) ->
  $translateProvider.translations "en-US",
    HOME: "Home"
    # Here we must add translations for english language

  $translateProvider.translations "es-ES",
    HOME: "Inicio"
    # Here we must add translations for spanish language


  $translateProvider.preferredLanguage (if navigator.language is "es" then "es-ES" else navigator.language)
]