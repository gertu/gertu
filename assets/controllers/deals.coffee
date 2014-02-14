angular.module("mean.deals").controller "DealsController", ["$scope",
"$routeParams", "$location", "Global", "Deals", "DealsCategory", "DealsShop", "AppAlert", "$http", ($scope,
  $routeParams, $location, Global, Deals, DealsCategory, DealsShop, AppAlert, $http) ->
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
      image: @image
      quantity: @quantity
      average: @average
    )
    deal.$save (response) ->
      $location.path "/"


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
      $location.path "/admin/deals/" + deal._id
      $scope.global.deal = deal

  $scope.addComent = () ->
    deal = $scope.deal
    comment = $scope.comment
    if not comment.rating?
      comment.rating = 0
    
    $http(
      url: "/api/v1/deals/" + deal._id + "/addComment"
      method: "PUT"
      data: $scope.comment
    )
    .success (data, status) ->
      $scope.deal = data
      AppAlert.add "success","ADDED_COMMENT"

  truncateDecimals = (number) ->
    Math[(if number < 0 then "ceil" else "floor")] number


  $scope.calcdiscount = ->
    if @price
      price = @price
      gertuprice = @gertuprice
      discount = 100 - (gertuprice * 100 / price)
      $scope.discount = truncateDecimals(discount)
    else
      console.log("bai")
      price = $scope.deal.price
      gertuprice = $scope.deal.gertuprice
      discount = 100 - (gertuprice * 100 / price)
      $scope.deal.discount = truncateDecimals(discount)


  $scope.calcgertuprice = ->
    if @price
      price = @price
      discount = @discount
      gertuprice = price - (discount * price / 100)
      $scope.gertuprice = truncateDecimals(gertuprice)
    else
      console.log("bai")
      price = $scope.deal.price
      discount = $scope.deal.discount
      gertuprice = price - (discount * price / 100)
      $scope.deal.gertuprice = truncateDecimals(gertuprice)


]