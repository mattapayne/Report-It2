angular.module('ReportIt.forgot_password.controllers').controller('ForgotPasswordController', ['$scope', 'ForgotPasswordService', 'SharedScopeResponseHandling',
  function($scope, ForgotPasswordService, SharedScopeResponseHandling) {    

    var self = this;
    SharedScopeResponseHandling.mixin($scope);
    var reset_request = {email: '', password: '', password_confirmation: ''};
    $scope.reset_request = angular.copy(reset_request);
    
    $scope.changePassword = function() {
      ForgotPasswordService.changePassword($scope.reset_request).
        success(function(response) {
          $scope.setSuccess(response.messages);
          $scope.reset_request = angular.copy(reset_request);
          $scope.forgot_password_form.$setPristine();
      }).error(function(response) {
          $scope.setError(response.messages);
      });
    };
  }
]);