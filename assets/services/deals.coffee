#Offers service used for offers REST endpoint
angular.module("mean.deals").factory "Deals", ["$resource", ($resource) ->
  $resource "/api/v1/deals/:dealId/:action",
    dealId: "@_id"
    action: "@action"
  ,
    update:
      method: "PUT"
    reserve:
      method: "POST"

]