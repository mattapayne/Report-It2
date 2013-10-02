angular.module('ReportIt.report.controllers').controller('NewReportController',
  ['$scope', 'ReportService', 'SharedScopeResponseHandling',
  function($scope, ReportService, SharedScopeResponseHandling) {    
    
      var self = this;
      SharedScopeResponseHandling.mixin($scope);
      $scope.snippets = [];
      $scope.report = null;
      $scope.reportTemplates = [];
      $scope.dataLoading = true;
      
      $scope.redactorOptions = {
        imageUpload : ReportIt.routes.api_v1_image_upload_path(),
        clipboardUploadUrl: ReportIt.routes.api_v1_image_upload_path(),
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
      
      //TODO - this will have to get tags for either a report or a template
      $scope.queryTags = {
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
          $scope.dataLoading = false;
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
        var bc = "New ";
        if ($scope.report) {
            bc += $scope.report.report_type == 'report' ? "Report" : "Template";
            if ($scope.report.name && $scope.report.name.length > 0) {
                bc += ": " + $scope.report.name;
            }
        }
        return bc;
      }
  }
]);