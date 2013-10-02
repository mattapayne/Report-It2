angular.module('ReportIt.dashboard.services').service('DashboardService', ['$http', '$q', '$window',
function($http, $q, $window) {
    
    this.getReports = function(tags, searchTerm, reportType, page, resultsPerPage) {
        tags = angular.isUndefined(tags) || tags === null ? [] : tags;
        searchTerm = angular.isUndefined(searchTerm) || searchTerm === null ? "" : searchTerm;
        reportType = angular.isUndefined(reportType) || reportType === null ? "" : reportType;
        page = angular.isUndefined(page) || page === null ? "" : page;
        resultsPerPage = angular.isUndefined(resultsPerPage) || resultsPerPage === null ? "" : resultsPerPage;
        return $http.get(ReportIt.routes.api_v1_get_reports_path({
            tags: tags.join(','),
            term: searchTerm,
            report_type: reportType,
            page: page,
            per_page: resultsPerPage}));
    };
    
    this.copyReport = function(report) {
      return $http.post(ReportIt.routes.api_v1_copy_report_path(report.id));  
    };
    
    this.destroyReport = function(report) {
        return $http.delete(ReportIt.routes.api_v1_destroy_report_path(report.id));
    };
    
    this.editReport = function(report) {
        $window.location.href = ReportIt.routes.edit_report_path(report.id);
    };
    
    this.addReport = function(options) {
        var type = angular.isUndefined(options.type) || options.type === null ? 'report' : options.type;
        $window.location.href = ReportIt.routes.new_report_path(type);
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
        
    this.getSharingForReport = function(report) {
        return $http.get(ReportIt.routes.api_v1_get_shares_path(report.id));
    };
    
    this.updateReportShare = function(report, share, shareStatus) {
        return $http.put(ReportIt.routes.api_v1_update_share_path(report.id),
                  angular.toJson({share: { user_id: share.id, shared: shareStatus }}));
    };
}]);