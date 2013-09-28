angular.module('ReportIt.report.services').
    service('ReportService', ['$http', '$q', 'REPORT_URLS', 'DASHBOARD_URLS', 'REPORT_TEMPLATE_URLS',
        function($http, $q, REPORT_URLS, DASHBOARD_URLS, REPORT_TEMPLATE_URLS) {
            this.get = function(reportId) {
                return $http.get(REPORT_URLS.get_report_url + reportId); 
            };
            
            this.save = function(report) {
                if (report.new_record) {
                    return $http.post(REPORT_URLS.create_report_url, angular.toJson({ report: report }));
                }
                return $http.put(REPORT_URLS.update_report_url + report.id, angular.toJson( { report: report }));
            };
                    
            this.getSnippets = function() {
                return $http.get(REPORT_URLS.get_snippets_url);
            };
            
            this.getReportTemplates = function() {
                return $http.get(DASHBOARD_URLS.get_report_templates_url);
            };
            
            this.getReportTemplate = function(reportTemplateId) {
                return $http.get(REPORT_TEMPLATE_URLS.get_report_template_url + reportTemplateId);
            };
}]);