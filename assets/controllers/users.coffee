angular.module("mean.users").controller "UsersController", ["$scope",
"$routeParams", "$location", "Global", "Users", ($scope, $routeParams,
  $location, Global, Users) ->
  $scope.global = Global

  $scope.find = ->
    user = $scope.user
    user.$profile (users) ->
      $scope.users = users

  $scope.findOne = ->
    Users.profile (user) ->
      $scope.user = user

  $scope.update = ->
    user = $scope.user
    user.$update ->
      $location.path "/profile"
      $scope.global.user = user

  $scope.minDate = new Date()
  $scope.dt = new Date()
]