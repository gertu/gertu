#Users service used for users REST endpoint
angular.module("mean.users").factory "Users", ["$resource", ($resource) ->
  $resource "/api/profile/:profileId",
    profileId: "@_id"
  ,
    update:
      method: "PUT"

    profile:
      method: "GET"

]