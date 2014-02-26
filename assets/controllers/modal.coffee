angular.module('mean.system').controller 'ModalInstanceCtrl', ['$scope', 'Global', '$modalInstance', 'reservation', ($scope, Global, $modalInstance, reservation) ->
  $scope.global = Global

  $scope.reservation = reservation

]