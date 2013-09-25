angular.module('ReportIt.contact.controllers').controller('ContactController', ['$scope', 'MessageService', 'SharedScopeResponseHandling',
  function($scope, MessageService, SharedScopeResponseHandling) {    
      
    var self = this;
    SharedScopeResponseHandling.addTo($scope);
    var emptyMessage = {email: '', subject: '', message_text: '', from: ''};
    $scope.message = angular.copy(emptyMessage);
    
    $scope.sendMessage = function() {
      MessageService.sendMessage($scope.message).
        success(function(response) {
          $scope.message = angular.copy(emptyMessage);
          $scope.contact_form.$setPristine();
          $scope.setSuccess(response.messages);
        
      }).error(function(response) {
        $scope.setError(response.messages);
      });
    };
  }
]);