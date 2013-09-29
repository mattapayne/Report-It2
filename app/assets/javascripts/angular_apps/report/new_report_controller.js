angular.module('ReportIt.report.controllers').controller('NewReportController',
  ['$scope', 'ReportService', 'IMAGE_UPLOAD_URLS', 'SharedScopeResponseHandling',
  function($scope, ReportService, IMAGE_UPLOAD_URLS, SharedScopeResponseHandling) {    
    
      var self = this;
      SharedScopeResponseHandling.mixin($scope);
      $scope.snippets = [];
      $scope.report = null;
      $scope.reportTemplates = [];
      
      $scope.redactorOptions = {
        imageUpload : IMAGE_UPLOAD_URLS.image_upload_url,
        clipboardUploadUrl: IMAGE_UPLOAD_URLS.image_upload_url,
        focus: true,
        minHeight: 550,
        linebreaks: true,
        paragraphy: false,
        plugins: ['clips', 'fontsize', 'fontfamily', 'fontcolor', 'fullscreen', 'tableborder']
      };
      
      $scope.uiSelect2Options = {
        allowClear: true,
        dropdownAutoWidth: false,
        containerCssClass: 'col-lg-12',
        formatNoMatches: function(term) {
          return "No report templates are available";
        }
      };
      
      //used for the tag selector
      $scope.queryTags = {
        prefetch: ReportService.lookupUserTags(),
        remote: ReportService.lookupUserTagsFiltered()
      };
      
      ReportService.get(null).
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
        
      ReportService.getReportTemplates().
        success(function(reportTemplates) {
          $scope.reportTemplates = reportTemplates;
        });
    
      $scope.updateSelectedReportTemplate = function() {
        if ($scope.report.report_template_id) {
          ReportService.getReportTemplate($scope.report.report_template_id).
            success(function(reportTemplate){
              $scope.report.content = reportTemplate.content;
              $scope.report.tags = reportTemplate.tags;
            });
        }
        else {
            $scope.report.content = '';
            $scope.report.tags = [];
        }
      };
      
      $scope.save = function() {
        ReportService.save($scope.report).
          success(function(response) {
            ReportService.editReport(response.report);
          }).
          error(function(response) {
            $scope.setError(response.messages);  
          });
      };
      
      $scope.getBreadcrumb = function() {
        var bc = "New Report";
        if ($scope.report && $scope.report.name && $scope.report.name.length > 0) {
          bc += ": " + $scope.report.name;
        }
        return bc;
      }
  }
]);