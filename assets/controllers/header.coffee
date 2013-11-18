angular.module("mean.system").controller "HeaderController", ["$scope", "Global", ($scope, Global) ->
  $scope.global = Global
  $scope.menu = [
    title: "Inicio"
    link: ""
  ]
  $scope.isCollapsed = false
]
