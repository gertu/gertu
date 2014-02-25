angular.module('mean.system').controller 'IndexController', [
  '$scope', 'Global','Index', '$q', '$timeout', 'AppAlert','GeolocationService',
  ($scope, Global, Index, $q,$timeout, AppAlert, geolocation) ->
    $scope.global = Global


    $scope.dealcount = 0
    $scope.reservationcount = 0
    $scope.usercount = 0
    $scope.shopcount = 0

    geolocation().then ((position) ->
      $scope.checkSteps(position)
    )

    $scope.checkSteps = (position)->
      prom = $q.defer()
      Index.getData.query
        userLong: position.coords.longitude
        userLat:  position.coords.latitude
      , (data) ->
        if $scope.global.user
          $scope.nearDeals = data[0].neardeals
          $scope.myComments = myComments()
          $scope.myBuys     = myBuys()
          $scope.myReserves = myReserves()
        else
          $scope.dealcount = data[0].dealcount
          $scope.usercount = data[0].usercount
          $scope.reservationcount = data[0].reservationcount
          $scope.shopcount = data[0].shopcount
          prom.resolve()
      prom.promise

    myComments = ->
      Index.getComments.query
        userId: $scope.global.user._id
      , (myComments) ->
        $scope.myComments = myComments

    myReserves = ->
      Index.getReserves.query
        userId: $scope.global.user._id
      , (myReserves) ->
        $scope.myReserves = myReserves

    myBuys = ->
      Index.getBuys.query
        userId: $scope.global.user._id
      , (myBuys) ->
        $scope.myBuys = myBuys
]