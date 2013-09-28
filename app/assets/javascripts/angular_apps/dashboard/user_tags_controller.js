angular.module('ReportIt.dashboard.controllers').controller('UserTagsController', ['$scope', 'DashboardService', 'SharedScopeResponseHandling',
  function($scope, DashboardService, SharedScopeResponseHandling) {
    
    var self = this;
    SharedScopeResponseHandling.mixin($scope);
    $scope.tags = [];
    
    DashboardService.getUserTags().
      success(function(tags) {
        $scope.tags = tags;
    });
      
    $scope.save = function() {
      DashboardService.updateUserTags($scope.tags).
        success(function(response) {
          $scope.setSuccess(response.messages);
        }).
        error(function(response) {
          $scope.setError(response.messages);
        });
    };
  }]);