angular.module('ReportIt.dashboard.controllers').controller('ReportsController', ['$scope', 'DashboardService', 'SharedScopeResponseHandling',
  function($scope, DashboardService, SharedScopeResponseHandling) {
    
    var self = this;
    SharedScopeResponseHandling.mixin($scope);
    $scope.reportsBeingDeleted = [];
    $scope.reports = [];
    $scope.openShares = {}; //keyed on item index - value is an object holding open/closed state and shares: { open: true, report_id: xxxx, shares: [] }
  
    $scope.$watch("reports", function() {
      $scope.openShares = {};  
    });
        
    $scope.$on('report-filters-changed', function(e, selectedTags) {
      DashboardService.getReports(selectedTags).
        success(function(reports) {
          $scope.reports = reports; 
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
    
    $scope.sharingOpenCssClass = function(index) {
      if($scope.displaySharing(index)) {
        return "sharing-open";
      };
      return '';
    };
    
    $scope.hideSharing = function(index) {
      var state = $scope.openShares[index];
      state.open = false;
    };
    
    $scope.share = function(index) {
      var report = $scope.reports[index];
      if (report.shared === false) {
        if (index in $scope.openShares === false) {
          DashboardService.getSharingForReport(report).
            success(function(response) {
              $scope.openShares[index] = { open: true, shares: response.users, report_id: report.id };   
            });
        }
        else {
          var state = $scope.openShares[index];
          state.open = true;
        }
      }
    };
    
    $scope.onClickShare = function(report, share) {
      var shareStatus = !share.has_share;
      DashboardService.updateReportShare(report, share, shareStatus).
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
            self.cleanupSharesForDeletedReport(report.id);
            $scope.setSuccess(response.messages);
        }).error(function(response) {
            self.stopManagingReport(index);
            $scope.setError(response.messages);
        });
    };
    
    self.cleanupSharesForDeletedReport = function(reportId) {
      var foundIndex = -1;
      for(var index in $scope.openShares) {
        var state = $scope.openShares[index];
        if (state.report_id === reportId) {
          foundIndex = index;
        }
      }
      if (foundIndex >= 0) {
        delete $scope.openShares[foundIndex];
      }
    };
  }
]);