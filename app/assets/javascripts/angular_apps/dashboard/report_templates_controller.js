angular.module('ReportIt.dashboard.controllers').controller('ReportTemplatesController', ['$scope', 'DashboardService',
  function($scope, DashboardService) {
    var self = this;
    $scope.reportTemplatesBeingDeleted = [];
    $scope.reportTemplates = [];
    
    DashboardService.getReportTemplates().success(function(reportTemplates) {
       $scope.reportTemplates = reportTemplates; 
    });
    
    $scope.deleting = function(index) {
        return _.contains($scope.reportTemplatesBeingDeleted, index);
    };
   
    $scope.destroy = function(index) {
        var reportTemplate = $scope.reportTemplates[index];
        if (confirm("Are you sure?")) {
            $scope.reportTemplatesBeingDeleted.push(index);
            self.deleteReportTemplate(index, reportTemplate);
        }
    };
    
    self.stopManagingReportTemplate = function(index) {
        $scope.reportTemplatesBeingDeleted =
                    _.reject($scope.reportTemplatesBeingDeleted, function(num) {
                        return num === index
                });
    };
    
    //since there is no 'finally' construct in Angular's promise returned by $http, we have to duplicate some code.
    self.deleteReportTemplate = function(index, reportTemplate) {
        DashboardService.destroyReportTemplate(reportTemplate).success(function() {
                $scope.reportTemplates.splice(index, 1);
                self.stopManagingReportTemplate(index);
            }).error(function() {
                self.stopManagingReportTemplate(index);
            });
    };
  }
]);