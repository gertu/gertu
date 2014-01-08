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
    flag: 'http://blogs.lainformacion.com/zoomboomcrash/files/2012/06/bandera-espa%C3%B1a.jpg'
    code: 'es'
  ,
    flag: 'http://gbwomensvolleyball.co.uk/wp-content/uploads/British-Flag1.png'
    code: 'en'
  ]

  $scope.filteredLangs = []

  $scope.selectLang = (code = document.documentElement.lang) ->
    $scope.filteredLangs = []
    for lang in $scope.langs
      if lang.code == (code)
        $scope.selectedLang = lang
      else
        $scope.filteredLangs.push lang
    console.log $scope.filteredLangs

    $translate.uses($scope.selectedLang.code)

  $scope.selectLang()
]
