angular.module('ReportIt.dashboard.controllers').controller('ReportTemplatesController', ['$scope', 'DashboardService', 'SharedScopeResponseHandling',
  function($scope, DashboardService, SharedScopeResponseHandling) {
    
    var self = this;
    SharedScopeResponseHandling.mixin($scope);
    $scope.reportTemplatesBeingDeleted = [];
    $scope.reportTemplates = [];
    $scope.openShares = {};
    
    $scope.$on('template-filters-changed', function(e, selectedTags) {
      DashboardService.getReportTemplates(selectedTags).
        success(function(reportTemplates) {
          $scope.reportTemplates = reportTemplates; 
        });
    });
    
    $scope.displaySharing = function(index) {
      var hasBeenLoaded = index in $scope.openShares;
      if (hasBeenLoaded === false) {
        return false;
      }
      else {
        var state = $scope.openShares[index];
        return state.open;
      }
    };
    
    $scope.hideSharing = function(index) {
      var state = $scope.openShares[index];
      state.open = false;
    };
    
    $scope.share = function(index) {
      var reportTemplate = $scope.reportTemplates[index];
      if (reportTemplate.shared === false) {
        if (index in $scope.openShares === false) {
          DashboardService.getSharingForReportTemplate(reportTemplate).
            success(function(response) {
              $scope.openShares[index] = { open: true, shares: response.users, report_template_id: reportTemplate.id };   
            });
        }
        else {
          var state = $scope.openShares[index];
          state.open = true;
        }
      }
    };
    
    $scope.onClickShare = function(template, share) {
      var shareStatus = !share.has_share;
      DashboardService.updateReportTemplateShare(template, share, shareStatus).
        success(function(response) {
          share.has_share = shareStatus;
        });
    };
    
    $scope.getShareTitle = function(share) {
      var title = share.full_name;
      if (share.has_share == true) {
        title += " (Currently sharing)";
      }
      else {
        title += " (Not currently shared with)";
      }
      return title;
    };
    
    $scope.hasShares = function(index) {
      if(index in $scope.openShares) {
        var state = $scope.openShares[index];
        return state && state.shares && state.shares.length > 0;
      }
      return false;
    };
    
    $scope.getShares = function(index) {
      if ($scope.hasShares(index)) {
        return $scope.openShares[index].shares;
      }
      return [];
    };
    
    $scope.isShared = function(index) {
      var reportTemplate = $scope.reportTemplates[index];
      return reportTemplate.shared == true;
    };
    
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
            self.cleanupSharesForDeletedReportTemplate(reportTemplate.id);
            $scope.setSuccess(response.messages);
        }).error(function(response) {
            self.stopManagingReportTemplate(index);
            $scope.setError(response.messages);
        });
    };
    
    self.cleanupSharesForDeletedReportTemplate = function(reportTemplateId) {
      var foundIndex = -1;
      for(var index in $scope.openShares) {
        var state = $scope.openShares[index];
        if (state.report_template_id === reportTemplateId) {
          foundIndex = index;
        }
      }
      if (foundIndex >= 0) {
        delete $scope.openShares[foundIndex];
      }
    };
  }
]);