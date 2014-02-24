angular.module("mean.system").controller "HeaderController", [
  "$scope", "Global", "$translate", ($scope, Global, $translate) ->
    $scope.global = Global
    $scope.menu = [
      title: "HOME"
      class: "icon-home-outline"
    ,
      title: "DEALS"
      link: "deals"
      class: "icon-thumbs-up"
    ,
      title: "ABOUT"
      link: "about"
      class: "icon-users"
    ,
      title: "CONTACT"
      link: "contact"
      class: "icon-mail"
    ]
    $scope.isCollapsed = false
]
