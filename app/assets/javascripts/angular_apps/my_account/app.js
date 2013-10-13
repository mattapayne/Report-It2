//services module
angular.module('ReportIt.my_account.services', ['ReportIt.constants']);
//controllers module
angular.module('ReportIt.my_account.controllers', ['ReportIt.my_account.services']);
//the main app module
angular.module('ReportIt.my_account', [
                                      'ReportIt.angular_loadmask',
                                      'ReportIt.validation',
                                      'ReportIt.my_account.controllers',
                                      'ReportIt.shared',
                                      'ReportIt-redactor',
                                      'ReportIt-directives',
                                      'ReportIt.security',
                                      'ui.select2']).
  config(["$httpProvider", "$sceProvider", "API_KEY", function(provider, $sceProvider, apiKey) {
    provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
    provider.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';
    provider.defaults.headers.common['X-Application-API-Key'] = apiKey;
    $sceProvider.enabled(false);
}]).run(['$rootScope', 'SharedScopeResponseHandling', 'Pagination', function($rootScope, SharedScopeResponseHandling, Pagination) {
    
   $rootScope.mixinCommonFunctionality = function(scope) {
      SharedScopeResponseHandling.mixin(scope);
    };
    
    $rootScope.createPaginator = function(response) {
      return new Pagination.Paginator({
                                  current: response.current_page,
                                  total: response.total_pages,
                                  has_next: response.has_next,
                                  has_previous: response.has_previous,
                                  per_page: response.per_page
                                 });
    };
  }]);;