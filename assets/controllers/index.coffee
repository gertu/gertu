angular.module('mean.system').controller 'IndexController', [
  '$scope', 'Global','Index', '$q', '$timeout', 'AppAlert',
  ($scope, Global, Index, $q,$timeout, AppAlert) ->
    $scope.global = Global


    showPosition = (position) ->
      $.getJSON "http://maps.googleapis.com/maps/api/geocode/json?latlng=" + position.coords.latitude + "," + position.coords.longitude + "&sensor=true", (data) ->
        $(".location-text").text data.results[1].formatted_address
        $scope.global.userLong = position.coords.longitude
        $scope.global.userLat = position.coords.latitude
        $scope.checkSteps(position.coords.longitude,position.coords.latitude)


    showError = (error) ->
      switch error.code
        when error.PERMISSION_DENIED
          $(".location-text").hide()

    $scope.dealcount = 0
    $scope.reservationcount = 0
    $scope.usercount = 0
    $scope.shopcount = 0

    $(document).ready ->
      navigator.geolocation.getCurrentPosition showPosition, showError  if navigator.geolocation
      setInterval(->
          navigator.geolocation.getCurrentPosition showPosition, showError  if navigator.geolocation
      , 120000)

    $scope.checkSteps = (paramLong,paramLat) ->
      prom = $q.defer()
      Index.getData.query
        userLong: paramLong
        userLat:  paramLat
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