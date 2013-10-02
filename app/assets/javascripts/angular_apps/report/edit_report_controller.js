angular.module('ReportIt.report.controllers').controller('EditReportController',
  ['$scope', '$q', 'ReportService', 'SharedScopeResponseHandling',
  function($scope, $q, ReportService, SharedScopeResponseHandling) {    
    
      var self = this;
      SharedScopeResponseHandling.mixin($scope);
      $scope.snippets = [];
      $scope.report = null;
      $scope.reportTemplates = [];
      
      $scope.redactorOptions = {
        imageUpload : ReportIt.routes.api_v1_image_upload_path(),
        clipboardUploadUrl: ReportIt.routes.api_v1_image_upload_path(),
        focus: true,
        minHeight: 550,
        linebreaks: true,
        paragraphy: false,
        plugins: ['clips', 'fontsize', 'fontfamily', 'fontcolor', 'fullscreen', 'tableborder']
      };
      
      //TODO - this will have to get tags for either a report or a template
      $scope.queryTags = {
        remote: ReportService.lookupUserTagsFiltered()
      };
      
      $scope.init = function(report_id) {

        var loadReport = ReportService.get(report_id, null);
        var loadSnippets = ReportService.getSnippets();
        var loadReportTemplates = ReportService.getReportTemplates();
        
        $q.all([loadReport, loadSnippets, loadReportTemplates]).then(function(aggregatedResults) {
            $scope.report = aggregatedResults[0].data;
            $scope.snippets = aggregatedResults[1].data;
            $scope.reportTemplates = aggregatedResults[2].data;
        });
      };
      
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
            $scope.report = response.report;
            $scope.setSuccess(response.messages);
          }).
          error(function(response) {
            $scope.setError(response.messages);  
          });
      };
      
      $scope.getBreadcrumb = function() {
        var bc = "Edit ";
        if ($scope.report) {
            bc += $scope.report.report_type == 'report' ? "Report" : "Template";
            if($scope.report.name && $scope.report.name.length > 0) {
                bc += ": " + $scope.report.name;
            }
        }
        return bc;
      }
  }
]);