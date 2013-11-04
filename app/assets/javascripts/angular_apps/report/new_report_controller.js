angular.module('ReportIt.report.controllers').controller('NewReportController',
  ['$scope', '$q', 'ReportService', function($scope, $q, ReportService) {    
    
      var self = this;
      
      $scope.mixinCommonFunctionality($scope);

      $scope.snippets = [];
      $scope.report = null;
      $scope.reportTemplates = [];
      $scope.tagsRemoteUrl = ReportService.lookupUserTagsFiltered()
      
      $scope.redactorOptions = {
        imageUpload : ReportIt.routes.api_v1_upload_redactor_image_path(),
        clipboardUploadUrl: ReportIt.routes.api_v1_upload_redactor_image_path(),
        focus: true,
        minHeight: 550,
        linebreaks: true,
        paragraphy: false,
        plugins: ['clips', 'fontsize', 'fontfamily', 'fontcolor', 'fullscreen', 'tableborder']
      };
      
      $scope.redactorHeaderOptions = angular.copy($scope.redactorOptions);
      $scope.redactorHeaderOptions.minHeight = 80;
      $scope.redactorFooterOptions = angular.copy($scope.redactorOptions);
      $scope.redactorFooterOptions.minHeight = 80;
      
      $scope.init = function(reportType) {

        var loadReport = ReportService.get(null, reportType);
        var loadSnippets = ReportService.getSnippets();
        var loadReportTemplates = ReportService.getReportTemplates();
        
        $q.all([loadReport, loadSnippets, loadReportTemplates]).then(function(aggregatedResults) {
            $scope.report = aggregatedResults[0].data;
            $scope.snippets = aggregatedResults[1].data;
            $scope.reportTemplates = aggregatedResults[2].data.reports;
        });
      };
    
      $scope.updateSelectedReportTemplate = function() {
        if ($scope.report.report_template_id) {
          ReportService.getReportTemplate($scope.report.report_template_id).
            success(function(reportTemplate){
              $scope.report.content = reportTemplate.content;
              $scope.report.tags = reportTemplate.tags;
              $scope.report.header = reportTemplate.header;
              $scope.report.footer = reportTemplate.footer;
            });
        }
        else {
            $scope.report.content = '';
            $scope.report.tags = [];
            $scope.report.header = '';
            $scope.report.footer = '';
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