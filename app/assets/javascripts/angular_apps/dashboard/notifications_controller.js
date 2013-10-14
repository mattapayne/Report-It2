angular.module('ReportIt.dashboard.controllers').controller('NotificationsController', ['$scope', 'DashboardService',
  function($scope, DashboardService) {
    
    var self = this;
    
    $scope.mixinCommonFunctionality($scope);
    
    $scope.notifications = [];
    $scope.currentPage = null;
    $scope.pagination = null;
    
    self.loadNotifications = function() {
      DashboardService.getNotifications($scope.currentPage, 3).
        success(function(response) {
          $scope.notifications = response.notifications;
          $scope.pagination = $scope.createPaginator(response);
        }).
        error(function(response) {
          $scope.setError(response.messages);
        }); 
    };
    
    self.loadNotifications();
    
    $scope.pageTo = function(page) {
      if(!angular.isUndefined(page) && page !== null && page !== $scope.currentPage)
      {
        $scope.currentPage = page;
        self.loadNotifications(); 
      }
    };
  }]);