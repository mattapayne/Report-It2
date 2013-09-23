angular.module('ReportIt.contact.controllers', [
                'ReportIt.contact.services']).
        controller('ContactController',
               ['$scope', 'MessageService',
                function($scope, MessageService) {
      
      var self = this;
      var SUCCESS = 1;
      var ERROR = 2;
      var NONE = 3;
      var emptyMessage = {email: '', subject: '', message_text: '', from: ''};
      
      $scope.message = angular.copy(emptyMessage);
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
      
      $scope.sendMessage = function() {
        MessageService.sendMessage($scope.message).success(function(response) {
          $scope.result.type = SUCCESS;
          $scope.result.value = response.message;
          $scope.message = angular.copy(emptyMessage);
          $scope.contact_form.$setPristine();
          
        }).error(function(response) {
          $scope.result.type = ERROR;
          $scope.result.value = response.message;
        });
      };
    }
]);