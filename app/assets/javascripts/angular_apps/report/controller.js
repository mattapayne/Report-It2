angular.module('ReportIt.report.controllers').controller('ReportController',
                                                                  ['$scope', 'ReportService', 'IMAGE_UPLOAD_URLS', 'SharedScopeResponseHandling',
  function($scope, ReportService, IMAGE_UPLOAD_URLS, SharedScopeResponseHandling) {    
    
      var self = this;
      SharedScopeResponseHandling.mixin($scope);
      $scope.snippets = [];
      $scope.report = null;
      
      $scope.redactorOptions = {
        imageUpload : IMAGE_UPLOAD_URLS.image_upload_url,
        clipboardUploadUrl: IMAGE_UPLOAD_URLS.image_upload_url,
        focus: true,
        minHeight: 550,
        linebreaks: true,
        paragraphy: false,
        plugins: ['clips', 'fontsize', 'fontfamily', 'fontcolor', 'fullscreen', 'tableborder']
      };
      
      $scope.init = function(report_id) {
        ReportService.get(report_id).
          success(function(report) {
            $scope.report = report;
          }).
          error(function(response) {
            $scope.setError(response.messages);  
          });
          
        ReportService.getSnippets().
          success(function(snippets) {
            $scope.snippets = snippets
          });
      };
      
      $scope.save = function() {
        ReportService.save($scope.report).
          success(function(response) {
            $scope.report = response.report;
            $scope.setSuccess(response.messages);
          }).
          error(function(response) {
            $scope.setError(response.messages);  
          });
      };
      
      $scope.getBreadcrumb = function() {
        var bc = '';
        if ($scope.report !== null) {
          if ($scope.report.new_record == true) {
            bc = 'New Report';
          }
          else {
            bc = 'Editing Report';
          }
          if ($scope.report.name && $scope.report.name.length > 0) {
            bc += ": '" + $scope.report.name + "'";
          }
        }
        return bc;
      }
  }
]);