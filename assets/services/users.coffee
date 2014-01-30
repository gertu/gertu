#Users service used for users REST endpoint
angular.module("mean.users").factory "Users", ["$resource", ($resource) ->
  $resource "/api/v1/profile/:profileId",
    profileId: "@_id"
  ,
    update:
      method: "PUT"

    profile:
      method: "GET"

]