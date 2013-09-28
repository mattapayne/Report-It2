angular.module('ReportIt.dashboard.controllers').controller('ReportTemplatesController', ['$scope', 'DashboardService', 'SharedScopeResponseHandling',
  function($scope, DashboardService, SharedScopeResponseHandling) {
    
    var self = this;
    SharedScopeResponseHandling.mixin($scope);
    $scope.reportTemplatesBeingDeleted = [];
    $scope.reportTemplates = [];
    
    /*DashboardService.getReportTemplates().success(function(reportTemplates) {
       $scope.reportTemplates = reportTemplates; 
    });*/
    
    $scope.$on('template-filters-changed', function(e, selectedTags) {
      DashboardService.getReportTemplates(selectedTags).
        success(function(reportTemplates) {
          $scope.reportTemplates = reportTemplates; 
        });
    });
    
    $scope.edit = function(index) {
      var reportTemplate = $scope.reportTemplates[index];
      DashboardService.editReportTemplate(reportTemplate);
    };
    
    $scope.add = function() {
      DashboardService.addReportTemplate();
    };
    
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
        DashboardService.destroyReportTemplate(reportTemplate).
          success(function(response) {
            $scope.reportTemplates.splice(index, 1);
            self.stopManagingReportTemplate(index);
            $scope.setSuccess(response.messages);
        }).error(function(response) {
            self.stopManagingReportTemplate(index);
            $scope.setError(response.messages);
        });
    };
  }
]);