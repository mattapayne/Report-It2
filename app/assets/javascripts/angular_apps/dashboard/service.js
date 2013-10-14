angular.module('ReportIt.dashboard.services').service('DashboardService', ['$http', '$q', '$window',
function($http, $q, $window) {
    
    this.getReports = function(tags, allInTags, searchTerm, reportType, status, page, resultsPerPage) {
        tags = angular.isUndefined(tags) || tags === null ? [] : tags;
        allInTags = angular.isUndefined(allInTags) || allInTags === null ? true : allInTags;
        searchTerm = angular.isUndefined(searchTerm) || searchTerm === null ? "" : searchTerm;
        reportType = angular.isUndefined(reportType) || reportType === null ? "" : reportType;
        status = angular.isUndefined(status) || status === null ? "" : status;
        page = angular.isUndefined(page) || page === null ? "" : page;
        resultsPerPage = angular.isUndefined(resultsPerPage) || resultsPerPage === null ? "" : resultsPerPage;
        return $http.get(ReportIt.routes.api_v1_get_reports_path({
            tags: tags.join(','),
            all_in_tags: allInTags,
            search_term: searchTerm,
            report_type: reportType,
            status: status,
            page_number: page,
            per_page: resultsPerPage}));
    };
    
    this.getNotifications = function(page, resultsPerPage) {
        page = angular.isUndefined(page) || page === null ? "" : page;
        resultsPerPage = angular.isUndefined(resultsPerPage) || resultsPerPage === null ? "" : resultsPerPage;
        return $http.get(ReportIt.routes.api_v1_get_notifications_path({
            page_number: page,
            per_page: resultsPerPage
        }));
    };
    
    this.exportReport = function(format, report) {
      $window.location.href = ReportIt.routes.export_report_path(format, report.id);  
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