angular.module("mean.system").controller "HeaderController", [
  "$scope", "Global", "$translate", ($scope, Global, $translate) ->
    $scope.global = Global
    $scope.menu = [
      title: "HOME"
    ,
      title: "DEALS"
      link: "deals"
    ,
      title: "ABOUT"
      link: "about"
    ,
      title: "CONTACT"
      link: "contact"
    ]
    $scope.isCollapsed = false
]
