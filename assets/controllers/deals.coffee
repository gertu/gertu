angular.module("mean.deals").controller "DealsController", ["$scope",
"$routeParams", "$location", "Global", "Deals", "DealsCategory", ($scope, $routeParams,
  $location, Global, Deals, DealsCategory) ->
  $scope.global = Global

  $scope.create = ->
    deal = new Deals(
      name: @name,
      price: @price,
      shop: $scope.global.shop._id,
      categoryname: @categoryname
    )
    console.log(deal)
    deal.$save (response) ->
      $location.path "/deals"

    @title = ""


  $scope.find = ->
    Deals.query (deals) ->
      $scope.deals = deals


  $scope.showdealcategories = ->
    DealsCategory.query (categories) ->
      $scope.categories = categories


  $scope.findOne = ->
    Deals.get
      dealId: $routeParams.dealId
    , (deal) ->
      $scope.deal = deal


  $scope.remove = (deal) ->
    if deal
      deal.$remove()
      for i of $scope.deals
        $scope.deals.splice i, 1  if $scope.deals[i] is deal
    else
      $scope.deal.$remove()
      $location.path "/deals"

  $scope.update = ->
    deal = $scope.deal
    deal.$update ->
      $location.path "/deals/" + deal._id
      $scope.global.deal = deal


  $scope.rate = 7
  $scope.max = 10
  $scope.isReadonly = true

]