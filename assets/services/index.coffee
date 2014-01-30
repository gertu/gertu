#Index service used for index REST endpoint
angular.module("mean.system").factory "Index", ["$resource", ($resource) ->
  $resource "/api/v1/webData",{userLong: "@userLong",userLat: "@userLat"},
    getData:
      method: "GET"
      isArray: true

]