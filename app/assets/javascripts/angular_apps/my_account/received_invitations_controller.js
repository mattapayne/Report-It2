angular.module('ReportIt.my_account.controllers').controller('ReceivedInvitationsController', ['$scope', 'MyAccountService', 'SharedScopeResponseHandling', 'Pagination',
  function($scope, MyAccountService, SharedScopeResponseHandling, Pagination) {
  
    var self = this;
    SharedScopeResponseHandling.mixin($scope);
    
    $scope.invitations = [];
    $scope.pagination = null;
    
}]);