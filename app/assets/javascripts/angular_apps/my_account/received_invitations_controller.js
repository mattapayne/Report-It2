angular.module('ReportIt.my_account.controllers').controller('ReceivedInvitationsController', ['$scope', 'MyAccountService',
  function($scope, MyAccountService) {
  
   var self = this;
   
   $scope.mixinCommonFunctionality($scope);

    $scope.invitations = [];
    $scope.pagination = null;
    $scope.currentPage = null;
    
    self.loadReceivedInvitations = function() {
      MyAccountService.getReceivedInvitations($scope.currentPage).
        success(function(response) {
          $scope.invitations = response.invitations;
          $scope.pagination = $scope.createPaginator(response);
        }).
        error(function(response) {
          $scope.setError(response.messages);  
        });
    };
    
    self.loadReceivedInvitations();
    
    $scope.acceptInvitation = function(invitation) {
      MyAccountService.acceptInvitation(invitation).
        success(function(response) {
          $scope.setSuccess(response.messages);
          self.loadReceivedInvitations();
        }).
        error(function(response) {
          $scope.setError(response.messages);
        });  
    };
    
      $scope.rejectInvitation = function(invitation) {
      MyAccountService.rejectInvitation(invitation).
        success(function(response) {
          $scope.setSuccess(response.messages);
          self.loadReceivedInvitations();
        }).
        error(function(response) {
          $scope.setError(response.messages);
        });  
    };
    
    $scope.pageTo = function(page) {
      if (!angular.isUndefined(page) && page !== null && page !== $scope.currentPage) {
        $scope.currentPage = page;
        self.loadReceivedInvitations();
      }
    };
    
}]);