angular.module("mean.deals").controller "DealsController", ["$scope",
"$routeParams", "$location", "Global", "Deals", ($scope, $routeParams,
  $location, Global, Deals) ->
  $scope.global = Global

  $scope.create = ->
    deal = new Deals(
      name: @name,
      price: @price
    )
    deal.$save (response) ->
      $location.path "/deals"

    @title = ""

  $scope.find = ->
    Deals.query (deals) ->
      $scope.deals = deals


  $scope.findOne = ->
    Deals.get
      dealId: $routeParams.dealId
    , (deal) ->
      $scope.deal = deal


  $scope.rate = 7
  $scope.max = 10
  $scope.isReadonly = true

]