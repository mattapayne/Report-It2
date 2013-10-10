angular.module('ReportIt.my_account.controllers').controller('ReceivedInvitationsController', ['$scope', 'MyAccountService',
  function($scope, MyAccountService) {
  
    var self = this;

    $scope.invitations = [];
    $scope.pagination = null;
    
}]);