angular.module('ReportIt.report_template.services').
    service('ReportTemplateService', ['$http', '$q', 'REPORT_TEMPLATE_URLS',
        function($http, $q, REPORT_TEMPLATE_URLS) {
            this.get = function(reportTemplateId) {
                return $http.get(REPORT_TEMPLATE_URLS.get_report_template_url + reportTemplateId); 
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
}]);