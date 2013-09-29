angular.module('ReportIt.report.services').
    service('ReportService', ['$http', '$q', '$window', 'REPORT_URLS', 'DASHBOARD_URLS', 'REPORT_TEMPLATE_URLS',
        function($http, $q, $window, REPORT_URLS, DASHBOARD_URLS, REPORT_TEMPLATE_URLS) {
            this.get = function(reportId) {
                if (reportId) {
                    return $http.get(REPORT_URLS.get_report_json_url + reportId); 
                }
                return $http.get(REPORT_URLS.get_new_report_json_url); 
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
                return $http.get(DASHBOARD_URLS.get_report_templates_url + "?tags=all");
            };
            
            this.getReportTemplate = function(reportTemplateId) {
                return $http.get(REPORT_TEMPLATE_URLS.get_report_template_json_url + reportTemplateId);
            };
            
            this.lookupUserTags = function() {
                return DASHBOARD_URLS.get_user_tags_url + "/report";
            };
            
            this.lookupUserTagsFiltered = function() {
                return DASHBOARD_URLS.get_user_tags_url + "/report?query=%QUERY";
            };
            
            this.editReport = function(report) {
                $window.location.href = DASHBOARD_URLS.edit_report_url + report.id;
            };
}]);