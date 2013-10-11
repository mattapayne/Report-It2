angular.module('ReportIt.my_account.controllers').controller('ChangePasswordController', ['$scope', 'MyAccountService',
  function($scope, MyAccountService) {
    
  var self = this;

  $scope.mixinCommonFunctionality($scope);
  
  $scope.password = '';
  $scope.password_confirmation = '';
  
  $scope.updatePassword = function() {
    MyAccountService.updatePassword($scope.password, $scope.password_confirmation).
      success(function(response) {
        $scope.setSuccess(response.messages);
      }).error(function(response) {
        $scope.setError(response.messages);
      });
  };
}]);