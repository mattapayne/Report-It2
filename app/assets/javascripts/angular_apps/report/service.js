angular.module('ReportIt.report.services').
    service('ReportService', ['$http', '$q', '$window', function($http, $q, $window) {
            this.get = function(reportId, reportType) {
                if (reportId) {
                    return $http.get(ReportIt.routes.api_v1_edit_report_path(reportId)); 
                }
                return $http.get(ReportIt.routes.api_v1_new_report_path(reportType)); 
            };
            
            this.save = function(report) {
                if (report.new_record) {
                    return $http.post(ReportIt.routes.api_v1_create_report_path(), angular.toJson({ report: report }));
                }
                return $http.put(ReportIt.routes.api_v1_update_report_path(report.id), angular.toJson( { report: report }));
            };
                    
            this.getSnippets = function() {
                return $http.get(ReportIt.routes.api_v1_get_snippets_path());
            };
            
            this.getReportTemplates = function() {
                return $http.get(ReportIt.routes.api_v1_get_reports_path({tags: '', term: '', report_type: "template", page: 1, per_page: 1000}));
            };
            
            this.getReportTemplate = function(reportId) {
                return $http.get(ReportIt.routes.api_v1_edit_report_path(reportId));
            };
            
            this.lookupUserTags = function() {
                return $http.get(ReportIt.routes.api_v1_get_user_tags_path('report'));
            };
            
            this.lookupUserTagsFiltered = function() {
                return decodeURIComponent(ReportIt.routes.api_v1_get_user_tags_path('report', {query: '%QUERY'}));
            };
            
            this.editReport = function(report) {
                $window.location.href = ReportIt.routes.edit_report_path(report.id);
            };
}]);