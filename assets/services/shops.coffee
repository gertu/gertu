#Offers service used for offers REST endpoint
angular.module("mean.shops").factory "Shop", ["$resource", ($resource) ->
  $resource "/api/v1/shops/:shopId",
    shopId: "@_id",
]