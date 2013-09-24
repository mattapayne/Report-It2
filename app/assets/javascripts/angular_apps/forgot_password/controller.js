angular.module('ReportIt.forgot_password.controllers').controller('ForgotPasswordController', ['$scope', 'ForgotPasswordService',
  function($scope, ForgotPasswordService) {    
      var self = this;
      var SUCCESS = 1;
      var ERROR = 2;
      var NONE = 3;
      var reset_request = {email: '', password: '', password_confirmation: ''};
      
      $scope.reset_request = angular.copy(reset_request);
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
      
      $scope.changePassword = function() {
        ForgotPasswordService.changePassword($scope.reset_request).success(function(response) {
          $scope.result.type = SUCCESS;
          $scope.result.value = response.messages;
          $scope.reset_request = angular.copy(reset_request);
          $scope.change_password_form.$setPristine();
          
        }).error(function(response) {
          $scope.result.type = ERROR;
          $scope.result.value = response.messages;
        });
      };
    }
]);