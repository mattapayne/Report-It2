angular.module('ReportIt.dashboard.controllers').controller('ReportsController', ['$scope', 'DashboardService', 'Pagination',
  function($scope, DashboardService, Pagination) {
    
    var self = this;
    
    $scope.mixinCommonFunctionality($scope);
    
    $scope.reports = [];
    $scope.searchTerm = "";
    $scope.reportTypes = ["Reports", "Templates"];
    $scope.statuses = ["Draft", "Published"];
    $scope.selectedReportType = "Reports";
    $scope.selectedStatus = "Published";
    $scope.selectedTags = [];
    $scope.tags = [];
    $scope.pagination = null;
    $scope.currentPage = null;
    $scope.allInTags = true;
    $scope.tagSelectionModeLabel = "Reports will have all of the selected tags.";
    
    $scope.$watch('allInTags', function(oldVal, newVal) {
      if (oldVal === false) {
        $scope.tagSelectionModeLabel = "Reports will have any of the selected tags.";
      }
      else {
        $scope.tagSelectionModeLabel = "Reports will have all of the selected tags.";
      }
      if (oldVal !== newVal) {
        self.loadReports();
      }
    });
    
    $scope.uiSelect2Options = {
        dropdownAutoWidth: false,
        width: '475px',
        formatNoMatches: function(term) {
          return "No tags are available";
        }
    };
    
    self.loadReports = function() {
      DashboardService.getReports($scope.selectedTags, $scope.allInTags, $scope.searchTerm, $scope.selectedReportType, $scope.selectedStatus, $scope.currentPage).
        success(function(response) {
          $scope.reports = response.reports;
          $scope.pagination = $scope.createPaginator(response);
        }).
        error(function(response) {
          $scope.setError(response.messages);  
        });
    };
    
    self.loadReports();
    
    DashboardService.getUserTags($scope.selectedReportType).
      success(function(response) {
        $scope.tags = response;  
    });
      
    $scope.pageTo = function(page) {
      if(!angular.isUndefined(page) && page !== null && page !== $scope.currentPage)
      {
        $scope.currentPage = page;
        self.loadReports(); 
      }
    };
    
    $scope.exportTo = function(format, report) {
      DashboardService.exportReport(format, report);  
    };
    
    $scope.statusChanged = function() {
      $scope.currentPage = 1;
      self.loadReports();
      self.reloadTags();
    };
    
    $scope.reportTypeChanged = function() {
      $scope.currentPage = 1;
      self.loadReports();
      self.reloadTags();
    };
    
    $scope.applyReportFilters = function() {
      self.loadReports();
    };
    
    $scope.shouldDisplaySharingForReport = function(report) {
      return report.shares_visible;
    };
    
    $scope.sharingOpenCssClass = function(report) {
      if(report.shares_visible) {
        return "sharing-open";
      };
      return '';
    };
    
    $scope.hideReportSharingForReport = function(report) {
      report.shares_visible = false;
    };
    
    $scope.openReportSharingArea = function(report) {
      if (report && report.shared_with_current_user === false) {
        if (self.reportSharesDoNotExist(report)) {
          DashboardService.getSharingForReport(report).
            success(function(response) {
              report.shares = response.users;
              report.shares_visible = true;
            });
        }
        else {
          report.shares_visible = true;
        }
      }
    };
    
    $scope.shareReport = function(report, share) {
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
    
    $scope.reportHasShares = function(report) {
      if (report.shares_visible && self.reportSharesExist(report) && report.shares.length > 0) {
        return true;
      }
      return false;
    };
    
    $scope.getReportShares = function(report) {
      if (report.shares_visible && self.reportSharesExist(report)) {
        return report.shares;
      }
      return [];
    };
    
    $scope.isSharedWithCurrentUser = function(report) {
      return report.shared_with_current_user === true;
    };
    
    $scope.editReport = function(report) {
      DashboardService.editReport(report);
    };
    
    $scope.addReport = function() {
      DashboardService.addReport({type: 'report'});
    };
    
    $scope.addReportTemplate = function() {
      DashboardService.addReport({type: 'template'});
    };
   
    $scope.destroy = function(report) {
        if (confirm("Are you sure?")) {
            self.deleteReport(report);
        }
    };
    
    $scope.copyReport = function(report) {
      DashboardService.copyReport(report).
        success(function(new_report) {
          DashboardService.editReport(new_report);
      });
    };
    
    //since there is no 'finally' construct in Angular's promise returned by $http, we have to duplicate some code.
    self.deleteReport = function(report) {
      DashboardService.destroyReport(report).
        success(function(response) {
          var index = self.getReportIndex(report);
          if (index >= 0) {
            $scope.reports.splice(index, 1);
          }
          $scope.setSuccess(response.messages);
        }).
        error(function(response) {
          $scope.setError(response.messages);
        });
    };
    
    self.reloadTags = function() {
      $scope.selectedTags = [];
      $scope.tags = [];
      DashboardService.getUserTags($scope.selectedReportType).
        success(function(response) {
          $scope.tags = response;  
        });
    };
    
    self.getReportIndex = function(report) {
      var index = -1;
      for (var i=0; i<$scope.reports.length; i++) {
        if ($scope.reports[i].id === report.id) {
          index = i;
          break;
        }
      }
      return index;
    };
    
    self.reportSharesDoNotExist = function(report) {
      return !self.reportSharesExist(report);
    }
    
    self.reportSharesExist = function(report) {
      return report && !angular.isUndefined(report.shares) && report.shares !== null;
    };
  }
]);