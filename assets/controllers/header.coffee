angular.module('mean.system').controller 'HeaderController', ['$scope', 'Global', '$translate', ($scope, Global, $translate) ->
  $scope.global = Global
  $scope.menu = [
    title: 'Inicio'
    link: ''
  ,
    title: 'Ofertas'
    link: 'deals'
  ,
    title: 'Acerca de'
    link: 'about'
  ,
    title: 'Contacto'
    link: 'contact'
  ]
  $scope.isCollapsed = false
  
  $scope.langs = [
    name: 'Español'
    code: 'es-ES'
  ,
    name: 'English'
    code: 'en-US'
  ]

  $scope.filteredLangs = []

  $scope.selectLang = (code = (if navigator.language is "es" then "es-ES" else navigator.language)) ->
    $scope.filteredLangs = []
    for lang in $scope.langs
      if lang.code == (code)
        $scope.selectedLang = lang
      else
        $scope.filteredLangs.push lang

    $translate.uses($scope.selectedLang.code)

  $scope.selectLang()
]
