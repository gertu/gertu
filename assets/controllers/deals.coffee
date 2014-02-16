angular.module("mean.deals").controller "DealsController", ["$scope",
"$routeParams", "$location", "Global", "Deals", "DealsCategory", "DealsShop", ($scope, $routeParams,
  $location, Global, Deals, DealsCategory, DealsShop) ->
  $scope.global = Global

  # $scope.days [
  #   "Lunes"
  #   "Martes"
  #   "Miercoles"
  #   "Jueves"
  #   ]

  # $scope.selection ['Lunes', 'Martes']

  # $scope.toggleSelection = toggleSelection = (fruitName) ->
  #   idx = $scope.selection.indexOf(fruitName)
    
  #   # is currently selected
  #   if idx > -1
  #     $scope.selection.splice idx, 1
    
  #   # is newly selected
  #   else
  #     $scope.selection.push fruitName
  #   return

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
      quantity: @quantity
    )
    deal.$save (response) ->
      $location.path "/admin/deals/photo/" + deal._id

  
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
    if confirm("Estas seguro")
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
      $scope.global.deal = deal
      $location.path "/admin/deals/photo/" + deal._id


  truncateDecimals = (number) ->
    Math[(if number < 0 then "ceil" else "floor")] number


  $scope.calcdiscount = ->
    if @price
      price = @price
      gertuprice = @gertuprice
      discount = 100 - (gertuprice * 100 / price)
      $scope.discount = truncateDecimals(discount)
    else
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
      price = $scope.deal.price
      discount = $scope.deal.discount
      gertuprice = price - (discount * price / 100)
      $scope.deal.gertuprice = truncateDecimals(gertuprice)


]