#Offers service used for offers REST endpoint
angular.module("mean.deals").factory "Deals", ["$resource", ($resource) ->
  $resource "/api/v1/deals/:dealId",
    dealId: "@_id"
  ,
    update:
      method: "PUT"

]