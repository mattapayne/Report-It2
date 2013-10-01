angular.module('ReportIt.dashboard.controllers').controller('UserTagsController', ['$scope', 'DashboardService',
  function($scope, DashboardService) {
    
    var self = this;
    $scope.selectedTags = [];
    $scope.tagType = null;
    $scope.tags = [];
    
    $scope.uiSelect2Options = {
        dropdownAutoWidth: false,
        width: '350px',
        formatNoMatches: function(term) {
          return "No tags are available";
        }
    };
    
    $scope.init = function(tagType) {
      $scope.tagType = tagType;
      DashboardService.getUserTags(tagType).
       success(function(tags) {
         $scope.tags = tags;
      });  
    };
    
    $scope.applyFilter = function() {
      self.notify($scope.selectedTags);
    };
    
    self.notify = function(tags) {
      if ($scope.tagType === 'report') {
        $scope.$emit('report-filters-changed', tags);
      }
      else {
        $scope.$emit('template-filters-changed', tags);
      }
    };
  }]);