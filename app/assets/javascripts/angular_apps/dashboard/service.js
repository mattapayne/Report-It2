angular.module('ReportIt.dashboard.services').service('DashboardService', ['$http', '$q', '$window',
function($http, $q, $window) {
    
    this.getReports = function(tags) {
        if (tags === null || tags.length == 0) {
            return $http.get(ReportIt.routes.api_v1_get_reports_path());
        }
        return $http.get(ReportIt.routes.api_v1_get_reports_path({tags: tags.join(',')}));
    };
    
    this.destroyReport = function(report) {
        return $http.delete(ReportIt.routes.api_v1_destroy_report_path(report.id));
    };
    
    this.editReport = function(report) {
        $window.location.href = ReportIt.routes.edit_report_path(report.id);
    };
    
    this.addReport = function() {
        $window.location.href = ReportIt.routes.new_report_path();
    };
    
    this.getReportTemplates = function(tags) {
        if (tags === null || tags.length == 0) {
            return $http.get(ReportIt.routes.api_v1_get_report_templates_path());
        }
        return $http.get(ReportIt.routes.api_v1_get_report_templates_path({tags: tags.join(',')}));
    };
    
    this.editReportTemplate = function(reportTemplate) {
         $window.location.href = ReportIt.routes.edit_report_template_path(reportTemplate);
    };
    
    this.addReportTemplate = function() {
        $window.location.href = ReportIt.routes.new_report_template_path();
    };
    
    this.destroyReportTemplate = function(reportTemplate) {
        return $http.delete(ReportIt.routes.api_v1_destroy_report_template_path(reportTemplate.id));
    };
    
    this.getSnippets = function() {
        return $http.get(ReportIt.routes.api_v1_get_snippets_path()); 
    };
    
    this.updateSnippet = function(snippet) {
        return $http.put(ReportIt.routes.api_v1_update_snippet_path(snippet.id), angular.toJson({ snippet: snippet }));
    };
    
    this.createSnippet = function(snippet) {
        return $http.post(ReportIt.routes.api_v1_create_snippet_path(), angular.toJson({ snippet: snippet })); 
    };
    
    this.destroySnippet = function(snippet) {
        return $http.delete(ReportIt.routes.api_v1_destroy_snippet_path(snippet.id));
    };
    
    this.getSettings = function() {
        return $http.get(ReportIt.routes.api_v1_get_settings_path()); 
    };
    
    this.updateSetting = function(setting) {
        return $http.put(ReportIt.routes.api_v1_update_settings_path(setting.id), angular.toJson({ setting: setting }));
    };
    
    this.getUserTags = function(tagType) {
        return $http.get(ReportIt.routes.api_v1_get_user_tags_path(tagType));  
    };
    
    this.getSharingForReportTemplate = function(reportTemplate) {
        return $http.get(ReportIt.routes.api_v1_get_shares_path("report_template", reportTemplate.id));
    };
    
    this.updateReportTemplateShare = function(reportTemplate, share, shareStatus) {
        return $http.put(ReportIt.routes.api_v1_update_share_path("report_template", reportTemplate.id),
                          angular.toJson({share: { user_id: share.id, shared: shareStatus }}));
    };
        
    this.getSharingForReport = function(report) {
        return $http.get(ReportIt.routes.api_v1_get_shares_path("report", report.id));
    };
    
    this.updateReportShare = function(report, share, shareStatus) {
        return $http.put(ReportIt.routes.api_v1_update_share_path("report", report.id),
                  angular.toJson({share: { user_id: share.id, shared: shareStatus }}));
    };
}]);