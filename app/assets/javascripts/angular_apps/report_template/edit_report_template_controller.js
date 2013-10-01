angular.module('ReportIt.report_template.controllers').controller('EditReportTemplateController',
  ['$scope', 'ReportTemplateService', 'SharedScopeResponseHandling',
  function($scope, ReportTemplateService, SharedScopeResponseHandling) {    
    
      var self = this;
      SharedScopeResponseHandling.mixin($scope);
      $scope.snippets = [];
      $scope.reportTemplate = null;
      
      $scope.redactorOptions = {
        imageUpload : ReportIt.routes.api_v1_image_upload_path(),
        clipboardUploadUrl: ReportIt.routes.api_v1_image_upload_path(),
        focus: true,
        minHeight: 550,
        linebreaks: true,
        paragraphy: false,
        plugins: ['clips', 'fontsize', 'fontfamily', 'fontcolor', 'fullscreen', 'tableborder']
      };
      
      $scope.queryTags = {
        prefetch: ReportTemplateService.lookupUserTags(),
        remote: ReportTemplateService.lookupUserTagsFiltered()
      };
      
      $scope.init = function(report_template_id) {
        ReportTemplateService.get(report_template_id).
          success(function(reportTemplate) {
            $scope.reportTemplate = reportTemplate;
          }).
          error(function(response) {
            $scope.setError(response.messages);  
          });
          
        ReportTemplateService.getSnippets().
          success(function(snippets) {
            $scope.snippets = snippets
          });
      };
      
      $scope.save = function() {
        ReportTemplateService.save($scope.reportTemplate).
          success(function(response) {
            $scope.reportTemplate = response.report_template;
            $scope.setSuccess(response.messages);
          }).
          error(function(response) {
            $scope.setError(response.messages);  
          });
      };
      
      $scope.getBreadcrumb = function() {
        var bc = "Edit Report Template";
        if ($scope.reportTemplate && $scope.reportTemplate.name && $scope.reportTemplate.name.length > 0) {
          bc += ": " + $scope.reportTemplate.name;
        }
        return bc;
      }
  }
]);