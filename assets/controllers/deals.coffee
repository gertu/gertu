angular.module("mean.deals").controller "DealsController", ["$scope",
"$routeParams", "$location", "Global", "Deals", "DealsCategory", "DealsShop", "AppAlert", "$http","$q", 'GeolocationService', ($scope,
  $routeParams, $location, Global, Deals, DealsCategory, DealsShop, AppAlert, $http,$q, geolocation) ->
  $scope.global = Global

  $scope.priceRange = [
    min: 0
    max: 15
    text: "0-15€"
  ,
    min: 15
    max: 30
    text: "15-30€"
  ,
    min: 30
    max: 45
    text: "30-45€"
  ,
    min: 60
    max: 75
    text: "60-75€"
  ,
    min: 75
    max: 90
    text: "75-90€"
  ]

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

  $scope.myMarkers = []
  $scope.mapOptions =
    center: new google.maps.LatLng($scope.global.userLat, $scope.global.userLong)
    zoom: 15
    maxZoom: 15
    mapTypeId: google.maps.MapTypeId.ROADMAP
    draggable: false
    disableDefaultUI: true


  $scope.addMarker = ($event, $params) ->
    $scope.myMarkers.push new google.maps.Marker(
      map: $scope.myMap
      position: new google.maps.LatLng($params.latitude, $params.longitude)
      deal: $params
    )
    return

  $scope.openMarkerInfo = (marker) ->
    $scope.currentMarker = marker
    $scope.currentMarkerName = marker.deal.name
    $scope.currentMarkerLat = marker.getPosition().lat()
    $scope.currentMarkerLng = marker.getPosition().lng()
    $scope.myInfoWindow.open $scope.myMap, marker
    return



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
      average: @average
    )
    deal.$save (response) ->
      $location.path "/admin/deals/photo/" + deal._id


  $scope.findbyshop = ->
    DealsShop.query
      shopId: $routeParams.shopId
    , (deals) ->
      $scope.deals = deals

  geolocation().then ((position) ->
    $scope.find(position)
  )


  $scope.find = (position)->
    $scope.uniqueCategories = []
    prom = $q.defer()
    console.log $scope.global.userLong
    Deals.getNearest
      userLong: position.coords.longitude
      userLat:  position.coords.latitude
    , (deals) ->
      console.log deals
      $scope.deals = deals
      $scope.filteredDeals = deals
      for deal in deals
        if deal.deal.categoryname not in $scope.uniqueCategories
          $scope.uniqueCategories.push deal.deal.categoryname
        $scope.addMarker '',deal.deal.shop.loc
      $scope.$apply

      prom.resolve()
    prom.promise

  $scope.filter = ->
    $scope.filteredDeals = []
    for deal in $scope.deals
      if ($scope.selectedCategory in $scope.uniqueCategories)  #si la categoria está seleccionada
        if ($scope.selectedPrice in $scope.priceRange)  #si el precio está seleccionado
          if deal.deal.categoryname == $scope.selectedCategory and deal.deal.gertuprice > $scope.selectedPrice.min and deal.deal.gertuprice < $scope.selectedPrice.max
            $scope.filteredDeals.push deal
        else if deal.deal.categoryname == $scope.selectedCategory
            $scope.filteredDeals.push deal
      else if ($scope.selectedPrice in $scope.priceRange)  #si el precio está seleccionado
            if deal.deal.gertuprice > $scope.selectedPrice.min and deal.deal.gertuprice < $scope.selectedPrice.max
              $scope.filteredDeals.push deal
      else
        $scope.filteredDeals = $scope.deals
    for deal in $scope.filteredDeals
          $scope.addMarker '',deal.deal.shop.loc


  $scope.showdealcategories = ->
    DealsCategory.query (categories) ->
      $scope.categories = categories


  $scope.findOne = ->
    Deals.get
      dealId: $routeParams.dealId
    , (deal) ->
      $scope.deal = deal

  $scope.reserve = ->
    deal = $scope.deal
    deal.$reserve
      dealId: $routeParams.dealId
      action: "reserve"
    , (cb) ->
      AppAlert.add "success", "Oferta reservada con éxito"


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


  $scope.addComent = ->
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
      AppAlert.add "success","COMMENT_" + status
    .error (data, status) ->
      AppAlert.add "error", "COMMENT_" + status


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