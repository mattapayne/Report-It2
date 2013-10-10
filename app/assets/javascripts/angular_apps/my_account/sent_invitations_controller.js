angular.module('ReportIt.my_account.controllers').controller('SentInvitationsController', ['$scope', 'MyAccountService',
  function($scope, MyAccountService) {
  
    var self = this;
    
    $scope.mixinCommonFunctionality($scope);

    $scope.invitations = [];
    $scope.pagination = null;
    $scope.currentPage = null;
    
    self.loadSentInvitations = function() {
      MyAccountService.getSentInvitations($scope.currentPage).
        success(function(response) {
          $scope.invitations = response.invitations;
          $scope.pagination = $scope.createPaginator(response);
        }).
        error(function(response) {
          $scope.setError(response.messages);  
        });
    };
    
    $scope.$on('invitation:sent', function() {
      self.loadSentInvitations();
    });
    
    self.loadSentInvitations();
    
    $scope.deleteSentInvitation = function(invitation) {
      MyAccountService.deleteSentInvitation(invitation).
        success(function(response) {
          $scope.setSuccess(response.messages);
          self.loadSentInvitations();
        }).
        error(function(response) {
          $scope.setError(response.messages);
        });  
    };
    
    $scope.pageTo = function(page) {
      if (!angular.isUndefined(page) && page !== null && page !== $scope.currentPage) {
        $scope.currentPage = page;
        self.loadSentInvitations();
      }
    };

}]);