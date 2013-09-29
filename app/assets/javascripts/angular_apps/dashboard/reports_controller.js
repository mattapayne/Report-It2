angular.module('ReportIt.dashboard.controllers').controller('ReportsController', ['$scope', 'DashboardService', 'SharedScopeResponseHandling',
  function($scope, DashboardService, SharedScopeResponseHandling) {
    
    var self = this;
    SharedScopeResponseHandling.mixin($scope);
    $scope.reportsBeingDeleted = [];
    $scope.reports = [];
    
    $scope.$on('report-filters-changed', function(e, selectedTags) {
      DashboardService.getReports(selectedTags).
        success(function(reports) {
          $scope.reports = reports; 
        });
    });
    
    $scope.share = function(index) {
      alert("Share!!");
    };
    
    $scope.isShared = function(index) {
      var report = $scope.reports[index];
      return report.shared == true;
    };
    
    $scope.edit = function(index) {
      var report = $scope.reports[index];
      DashboardService.editReport(report);
    };
    
    $scope.add = function() {
      DashboardService.addReport();
    };
    
    $scope.deleting = function(index) {
        return _.contains($scope.reportsBeingDeleted, index);
    };
   
    $scope.destroy = function(index) {
        var report = $scope.reports[index];
        if (confirm("Are you sure?")) {
            $scope.reportsBeingDeleted.push(index);
            self.deleteReport(index, report);
        }
    };
    
    self.stopManagingReport = function(index) {
        $scope.reportsBeingDeleted =
                    _.reject($scope.reportsBeingDeleted, function(num) {
                        return num === index
                });
    };
    
    //since there is no 'finally' construct in Angular's promise returned by $http, we have to duplicate some code.
    self.deleteReport = function(index, report) {
        DashboardService.destroyReport(report).
          success(function(response) {
            $scope.reports.splice(index, 1);
            self.stopManagingReport(index);
            $scope.setSuccess(response.messages);
        }).error(function(response) {
            self.stopManagingReport(index);
            $scope.setError(response.messages);
        });
    };
  }
]);