angular.module('ReportIt.register.controllers').controller('RegisterController', ['$scope', 'RegisterService', 'SharedScopeResponseHandling',
  function($scope, RegisterService, SharedScopeResponseHandling) {    
    
    var self = this;
    SharedScopeResponseHandling.addTo($scope);
    var emptyRegistration = {first_name: '', last_name: '', email: '', password: '', password_confirmation: ''};
    $scope.registration = angular.copy(emptyRegistration);
    
    $scope.register = function() {
      RegisterService.register($scope.registration).
        success(function(response) {
          $scope.registration = angular.copy(emptyRegistration);
          $scope.register_form.$setPristine();
          $scope.setSuccess(response.messages);
      }).error(function(response) {
          $scope.setError(response.messages);
      });
    };
  }
]);