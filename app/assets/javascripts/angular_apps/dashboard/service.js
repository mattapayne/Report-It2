angular.module('ReportIt.dashboard.services').service('DashboardService', ['$http', '$q', 'DASHBOARD_URLS', function($http, $q, DASHBOARD_URLS) {
    this.getOrganizations = function() {
        return $http.get(DASHBOARD_URLS.get_organizations_url); 
    };
    
    this.destroyOrganization = function(organization) {
        return $http.delete(DASHBOARD_URLS.delete_organization_url + organization.id);
    };
    
    this.createOrganization = function(organization) {
        return $http.post(DASHBOARD_URLS.create_organization_url, angular.toJson({ organization: organization }));  
    };
    
    this.updateOrganization = function(organization) {
        return $http.put(DASHBOARD_URLS.update_organization_url + organization.id, angular.toJson({ organization: organization }));
    };
    
    this.getReports = function() {
        return $http.get(DASHBOARD_URLS.get_reports_url); 
    };
    
    this.destroyReport = function(report) {
        return $http.delete(DASHBOARD_URLS.delete_report_url + report.id);
    };
    
    this.getReportTemplates = function() {
        return $http.get(DASHBOARD_URLS.get_report_templates_url); 
    };
    
    this.destroyReportTemplate = function(reportTemplate) {
        return $http.delete(DASHBOARD_URLS.delete_report_template_url + report_template.id);
    };
    
    this.getSnippets = function() {
        return $http.get(DASHBOARD_URLS.get_snippets_url); 
    };
    
    this.updateSnippet = function(snippet) {
        return $http.put(DASHBOARD_URLS.update_snippet_url + snippet.id, angular.toJson({ snippet: snippet }));
    };
    
    this.createSnippet = function(snippet) {
        return $http.post(DASHBOARD_URLS.create_snippet_url, angular.toJson({ snippet: snippet })); 
    };
    
    this.destroySnippet = function(snippet) {
        return $http.delete(DASHBOARD_URLS.delete_snippet_url + snippet.id);
    };
    
    this.getSettings = function() {
        return $http.get(DASHBOARD_URLS.get_settings_url); 
    };
    
    this.updateSetting = function(setting) {
        return $http.put(DASHBOARD_URLS.update_setting_url + setting.id, angular.toJson({ setting: setting }));
    };
}]);