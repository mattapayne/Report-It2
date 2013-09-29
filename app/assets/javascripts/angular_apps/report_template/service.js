angular.module('ReportIt.report_template.services').
    service('ReportTemplateService', ['$http', '$q', '$window', 'REPORT_TEMPLATE_URLS', 'DASHBOARD_URLS',
        function($http, $q, $window, REPORT_TEMPLATE_URLS, DASHBOARD_URLS) {
            this.get = function(reportTemplateId) {
                if (reportTemplateId) {
                    return $http.get(REPORT_TEMPLATE_URLS.get_report_template_json_url + reportTemplateId); 
                }
                return $http.get(REPORT_TEMPLATE_URLS.get_new_report_template_json_url); 
            };
            
            this.save = function(reportTemplate) {
                if (reportTemplate.new_record) {
                    return $http.post(REPORT_TEMPLATE_URLS.create_report_template_url, angular.toJson({ report_template: reportTemplate }));
                }
                return $http.put(REPORT_TEMPLATE_URLS.update_report_template_url + reportTemplate.id, angular.toJson( { report_template: reportTemplate }));
            };
                    
            this.getSnippets = function() {
                return $http.get(REPORT_TEMPLATE_URLS.get_snippets_url);
            };
            
            this.lookupUserTags = function() {
                return DASHBOARD_URLS.get_user_tags_url + "/template";
            };
            
            this.lookupUserTagsFiltered = function() {
                return DASHBOARD_URLS.get_user_tags_url + "/template?query=%QUERY";
            };
            
            this.editReportTemplate = function(reportTemplate) {
                $window.location.href = DASHBOARD_URLS.edit_report_template_url + reportTemplate.id;
            };
}]);