angular.module('ReportIt.report_template.controllers').controller('ReportTemplateController',
                                                                  ['$scope', 'ReportTemplateService', 'IMAGE_UPLOAD_URLS', 'SharedScopeResponseHandling',
  function($scope, ReportTemplateService, IMAGE_UPLOAD_URLS, SharedScopeResponseHandling) {    
    
      var self = this;
      SharedScopeResponseHandling.mixin($scope);
      $scope.snippets = [];
      $scope.reportTemplate = null;
      
      $scope.redactorOptions = {
        imageUpload : IMAGE_UPLOAD_URLS.image_upload_url,
        clipboardUploadUrl: IMAGE_UPLOAD_URLS.image_upload_url,
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
        var bc = '';
        if ($scope.reportTemplate !== null) {
          if ($scope.reportTemplate.new_record == true) {
            bc = 'New Report Template';
          }
          else {
            bc = 'Editing Report Template';
          }
          if ($scope.reportTemplate.name && $scope.reportTemplate.name.length > 0) {
            bc += ": '" + $scope.reportTemplate.name + "'";
          }
        }
        
        return bc;
      }
  }
]);