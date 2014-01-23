angular.module("mean.deals").controller "DealsController", ["$scope",
"$routeParams", "$location", "Global", "Deals", "DealsCategory", "DealsShop", ($scope, $routeParams,
  $location, Global, Deals, DealsCategory, DealsShop) ->
  $scope.global = Global

  $scope.create = ->
    deal = new Deals(
      name: @name,
      description: @description,
      price: @price,
      gertuprice: @gertuprice,
      discount: @discount,
      shop: $scope.global.shop._id,
      categoryname: $scope.categoryname
      datainit: @datainit
      dataend: @dataend
    )
    console.log(deal)
    deal.$save (response) ->
      $location.path "/"

    @title = ""


  $scope.findbyshop = ->
    DealsShop.query
      shopId: $routeParams.shopId
    , (deals) ->
      $scope.deals = deals


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
      $location.path "/"

  $scope.update = ->
    deal = $scope.deal
    deal.$update ->
      $location.path "/deals/" + deal._id
      $scope.global.deal = deal

  truncateDecimals = (number) ->
    Math[(if number < 0 then "ceil" else "floor")] number


  $scope.calcdiscount = ->
    price = @price
    gertuprice = @gertuprice
    discount = 100 - (gertuprice * 100 / price)
    $scope.discount = truncateDecimals(discount)


  $scope.calcgertuprice = ->
    price = @price
    discount = @discount
    gertuprice = price - (discount * price / 100)
    $scope.gertuprice = truncateDecimals(gertuprice)


  $scope.rate = 7
  $scope.max = 10
  $scope.isReadonly = true

]