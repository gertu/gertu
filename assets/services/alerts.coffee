angular.module("mean.system").factory 'AppAlert', ['$rootScope','$timeout', ($rootScope,$timeout) ->
  $rootScope.alerts = []
  alertService =
    add: (type, msg) ->
      $rootScope.alerts.push { type: type, msg: msg, close: -> alertService.closeAlert(this) }
      $timeout (->
        alertService.closeAlert($rootScope.alerts.length-1)
      ), 3000
    closeAlert: (alert) ->
      @closeAlertIdx $rootScope.alerts.indexOf(alert)
    closeAlertIdx: (index) ->
      $rootScope.alerts.splice index, 1
]