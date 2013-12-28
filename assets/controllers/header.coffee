angular.module('mean.system').controller 'HeaderController', ['$scope', 'Global', ($scope, Global) ->
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
]
