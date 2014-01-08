angular.module('mean').config ["$translateProvider", ($translateProvider) ->
  $translateProvider.translations "en",
    HOME: "Home"
    # Here we must add translations for english language

  $translateProvider.translations "es",
    HOME: "Inicio"
    # Here we must add translations for spanish language


  $translateProvider.preferredLanguage document.documentElement.lang
]