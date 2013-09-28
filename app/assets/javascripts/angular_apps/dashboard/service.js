angular.module('ReportIt.dashboard.services').service('DashboardService', ['$http', '$q', 'DASHBOARD_URLS', '$window',
function($http, $q, DASHBOARD_URLS, $window) {
    
    this.getReports = function(tags) {
        var qs = (tags && tags.length > 0) ? "?tags=" + tags.join(",") : "";
        return $http.get(DASHBOARD_URLS.get_reports_url + qs); 
    };
    
    this.destroyReport = function(report) {
        return $http.delete(DASHBOARD_URLS.delete_report_url + report.id);
    };
    
    this.editReport = function(report) {
        $window.location.href = DASHBOARD_URLS.edit_report_url + report.id;
    };
    
    this.addReport = function() {
        $window.location.href = DASHBOARD_URLS.add_report_url;
    };
    
    this.getReportTemplates = function(tags) {
        var qs = (tags && tags.length > 0) ? "?tags=" + tags.join(",") : "";
        return $http.get(DASHBOARD_URLS.get_report_templates_url + qs); 
    };
    
    this.editReportTemplate = function(reportTemplate) {
        $window.location.href = DASHBOARD_URLS.edit_report_template_url + reportTemplate.id;
    };
    
    this.addReportTemplate = function() {
        $window.location.href = DASHBOARD_URLS.add_report_template_url;
    };
    
    this.destroyReportTemplate = function(reportTemplate) {
        return $http.delete(DASHBOARD_URLS.delete_report_template_url + reportTemplate.id);
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
    
    this.getUserTags = function(tagType) {
        return $http.get(DASHBOARD_URLS.get_user_tags_url + "/" + tagType);  
    };
}]);