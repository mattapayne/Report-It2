angular.module('ReportIt.register.controllers', [
                'ReportIt.register.services']).
        controller('RegisterController',
               ['$scope', 'RegisterService',
                function($scope, RegisterService) {
      
      var self = this;
      var SUCCESS = 1;
      var ERROR = 2;
      var NONE = 3;
      var emptyRegistration = {first_name: '', last_name: '', email: '', password: '', password_confirmation: ''};
      
      $scope.registration = angular.copy(emptyRegistration);
      $scope.result = {type: NONE, value: ''};
      
      $scope.hasResult = function() {
        return $scope.result.type !== NONE;
      };
      
      $scope.resultIsError = function() {
        return $scope.result.type === ERROR;
      };
      
      $scope.resultIsSuccess = function() {
        return $scope.result.type === SUCCESS;
      };
      
      $scope.resultClasses = function() {
        var classes = '';
        if($scope.result.type === NONE) {
          return classes;
        }
        classes = 'alert';
        classes += $scope.result.type === ERROR ? ' alert-danger' : ' alert-success';
        return classes;
      };
      
      $scope.register = function() {
        RegisterService.register($scope.registration).success(function(response) {
          $scope.result.type = SUCCESS;
          $scope.result.value = response.message;
          $scope.registration = angular.copy(emptyRegistration);
          $scope.register_form.$setPristine();
          
        }).error(function(response) {
          $scope.result.type = ERROR;
          $scope.result.value = response.message;
        });
      };
    }
]);