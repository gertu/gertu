angular.module("mean.users").controller "UsersController", [
  "$scope", "$routeParams", "$location", "Global", "Users", "$route", "$q", "$timeout","AppAlert", (
  $scope, $routeParams, $location, Global, Users, $route, $q, $timeout,AppAlert) ->
    $scope.global = Global
    $scope.alerts = []

    $scope.time = false

    $scope.find = ->
      user = $scope.user
      prom = $q.defer()
      user.$profile (users) ->
        $scope.users = users
        prom.resolve()
      prom.promise

    $scope.findOne = ->
      prom = $q.defer()
      Users.profile (user) ->
        $scope.user = user
        prom.resolve()
      prom.promise

    $scope.update = ->
      $scope.time = false
      user = $scope.user
      prom = $q.defer()
      user.$update ->
        $location.path "/profile"
        $scope.global.user = user
        AppAlert.add "success","Perfil actualizado!"
        prom.resolve()
      prom.promise

    $scope.showWeeks = true
    $scope.toggleWeeks = ->
      $scope.showWeeks = not $scope.showWeeks

    $scope.clear = ->
      $scope.dt = null


    # Disable weekend selection
    $scope.disabled = (date, mode) ->
      mode is "day" and (date.getDay() is 0 or date.getDay() is 6)

    $scope.toggleMin = ->
      $scope.minDate = (if ($scope.minDate) then null else new Date())

    $scope.toggleMin()
    $scope.open = ($event) ->
      $event.preventDefault()
      $event.stopPropagation()
      $scope.opened = true

    $scope.dateOptions =
      "year-format"    : "'yy'"
      "starting-day"   : 1
      "show-weeks"     : false
      "show-button-bar": false


    $scope.formats = ["dd-MMMM-yyyy", "yyyy/MM/dd", "shortDate"]
    $scope.format  = $scope.formats[0]

    $scope.hobbies = [
      name: "Comida"
    ,
      name: "Deportes"
    ,
      name: "Música"
    ,
      name: "Tecnología"
    ]
]