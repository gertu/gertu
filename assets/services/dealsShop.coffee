angular.module("mean.deals").factory "DealsShop", ["$resource", ($resource) ->
  $resource "/api/v1/admin/deals/:shopId",
    shopId: "@_id"

]