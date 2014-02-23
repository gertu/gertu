angular.module("mean.system").factory "Index", ["$resource", ($resource) ->
  getComments: $resource "/api/v1/comments/:userId",
    query:
      userId : @_id
      method : "GET"
      isArray: true

  getReserves: $resource "/api/v1/myreserves/:userId",
    query:
      userId : @_id
      method : "GET"
      isArray: true

  getBuys: $resource "/api/v1/mybuys/:userId",
    query:
      userId : @_id
      method : "GET"
      isArray: true

  getData: $resource "/api/v1/webData",
    query:
      userLong: @userLong
      userLat : @userLat
      method  : "GET"
      isArray : true
]