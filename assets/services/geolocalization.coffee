angular.module("mean.system").factory "GeolocationService", [
  "$q"
  "$window"
  "$rootScope"
  ($q, $window, $rootScope) ->
    return ->
      deferred = $q.defer()
      unless $window.navigator
        $rootScope.$apply ->
          deferred.reject new Error("Geolocation is not supported")
          return

      else
        $window.navigator.geolocation.getCurrentPosition ((position) ->
          $rootScope.$apply ->
            deferred.resolve position
            return

          return
        ), (error) ->
          $rootScope.$apply ->
            deferred.reject error
            return

          return

      deferred.promise
]