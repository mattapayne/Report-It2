angular.module('ReportIt.report_template.services').
    service('ReportTemplateService', ['$http', '$q', '$window', function($http, $q, $window) {
            this.get = function(reportTemplateId) {
                if (reportTemplateId) {
                    return $http.get(ReportIt.routes.api_v1_edit_report_template_path(reportTemplateId));
                }
                return $http.get(ReportIt.routes.api_v1_new_report_template_path());
            };
            
            this.save = function(reportTemplate) {
                if (reportTemplate.new_record) {
                    return $http.post(ReportIt.routes.api_v1_create_report_template_path(),
                        angular.toJson({ report_template: reportTemplate }));
                }
                return $http.put(ReportIt.routes.api_v1_update_report_template_path(reportTemplate.id),
                            angular.toJson( { report_template: reportTemplate }));
            };
                    
            this.getSnippets = function() {
                return $http.get(ReportIt.routes.api_v1_get_snippets_path());
            };
            
            this.lookupUserTags = function() {
                return $http.get(ReportIt.routes.api_v1_get_user_tags_path('template'));
            };
            
            this.lookupUserTagsFiltered = function() {
                return decodeURIComponent(ReportIt.routes.api_v1_get_user_tags_path('template', {query: '%QUERY'}));
            };
            
            this.editReportTemplate = function(reportTemplate) {
                $window.location.href = ReportIt.routes.edit_report_template_path(reportTemplate.id);
            };
}]);