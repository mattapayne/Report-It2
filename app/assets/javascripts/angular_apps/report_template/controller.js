angular.module('ReportIt.report_template.controllers').controller('ReportTemplateController',
                                                                  ['$scope', 'ReportTemplateService', 'IMAGE_UPLOAD_URLS', 'SharedScopeResponseHandling',
  function($scope, ReportTemplateService, IMAGE_UPLOAD_URLS, SharedScopeResponseHandling) {    
    
      var self = this;
      SharedScopeResponseHandling.mixin($scope);
      $scope.requirementMessages = {};
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
      
      $scope.$watch('reportTemplate.name', function(newValue, oldValue) {
        if(!newValue || newValue.length === 0) {
          $scope.requirementMessages['reportTemplate.name'] = "Template name is required.";
        }
        else {
          delete $scope.requirementMessages['reportTemplate.name'];
        }
      });
      
      $scope.$watch('reportTemplate.content', function(newValue, oldValue) {
        if(!newValue || newValue.length === 0) {
          $scope.requirementMessages['reportTemplate.content'] = "Template content is required.";
        }
        else {
          delete $scope.requirementMessages['reportTemplate.content'];
        }
      });
      
      $scope.requirementsMessagesEmpty = function() {
        return _.isEmpty($scope.requirementMessages);
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
      
      $scope.isFormInvalid = function() {
        return $scope.reportTemplate == null || !$scope.reportTemplate.name || !$scope.reportTemplate.content;
      };
      
      $scope.save = function() {
        self.setSelectedOrganizations();
        ReportTemplateService.save($scope.reportTemplate).
          success(function(result) {
            window.location.href = result.redirect_url;
          }).
          error(function(response) {
            $scope.setError(response.messages);  
          });
      };
  }
]);