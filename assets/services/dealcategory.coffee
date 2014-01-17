#DealCategory service used for dealscategory REST endpoint
angular.module("mean.deals").factory "DealsCategory", ["$resource", ($resource) ->
  $resource "/api/v1/dealscategory/:dealcategoryId",
    dealId: "@_id"
  ,
    update:
      method: "PUT"

]