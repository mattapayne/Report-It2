angular.module('ReportIt.dashboard.services').factory('DashboardService', ['$http', '$q', function($http, $q) {
    return {
            getOrganizations: function() {
                return $http.get('/organizations'); 
            },
            destroyOrganization: function(organization) {
                return $http.delete('/organizations/destroy/' + organization.id);
            },
            createOrganization: function(organization) {
                return $http.post('/organizations/create', angular.toJson({ organization: organization }));  
            },
            updateOrganization: function(organization) {
                return $http.put('/organizations/update/' + organization.id, angular.toJson({ organization: organization }));
            },
            getReports: function() {
                return $http.get('/reports'); 
            },
            destroyReport: function(report) {
                return $http.delete('/reports/destroy/' + report.id);
            },
            getReportTemplates: function() {
                return $http.get('/report_templates'); 
            },
            destroyReportTemplate: function(reportTemplate) {
                return $http.delete('/report_templates/destroy/' + report_template.id);
            },
            getSnippets: function() {
                return $http.get('/snippets'); 
            },
            updateSnippet: function(snippet) {
                return $http.put('/snippets/' + snippet.id, angular.toJson({ snippet: snippet }));
            },
            createSnippet: function(snippet) {
                return $http.post('/snippets', angular.toJson({ snippet: snippet })); 
            },
            destroySnippet: function(snippet) {
                return $http.delete('/snippets/' + snippet.id);
            },
            getSettings: function() {
                return $http.get('/settings'); 
            },
            updateSetting: function(setting) {
                return $http.put('/settings/' + setting.id, angular.toJson({ setting: setting }));
            }
        };  
}]);