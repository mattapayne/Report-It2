angular.module('ReportIt.my_account.services').service('MyAccountService', ['$http', '$q', '$window',
function($http, $q, $window) {

    this.deleteSentInvitation = function(invitation) {
      return $http.delete(ReportIt.routes.api_v1_destroy_invitation_path(invitation.id));  
    };

    this.getSentInvitations = function(page, per_page) {
        return $http.get(ReportIt.routes.api_v1_get_invitations_by_type_path('sent', {page_number: page, per_page: per_page}));
    };
    
    this.stopSharing = function(associate, report) {
        return $http.put(ReportIt.routes.api_v1_update_share_path(report.id),
                  angular.toJson({share: { user_id: associate.id, shared: false }}))
    };
    
    this.getSharingForAssociate = function(associate) {
        return $http.get(ReportIt.routes.api_v1_get_shared_reports_by_associate_path(associate.id));
    };
    
    this.getPotentialAssociatesUrl = function() {
        return decodeURIComponent(ReportIt.routes.api_v1_get_potential_associates_path({q: "%QUERY"}));
    };
    
    this.sendInvitations = function(message, emails) {
        return $http.post(ReportIt.routes.api_v1_create_invitation_path(), angular.toJson({ invitation: { message: message, emails: emails}}));
    };
    
    this.disassociate = function(associate) {
        return $http.delete(ReportIt.routes.api_v1_destroy_association_path(associate.id));
    };
    
    this.getAssociates = function(page, per_page) {
        return $http.get(ReportIt.routes.api_v1_get_associates_path({page_number: page, per_page: per_page}));
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
}]);