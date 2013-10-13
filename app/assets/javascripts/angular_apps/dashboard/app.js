//services module
angular.module('ReportIt.dashboard.services', ['ReportIt.constants']);
//controllers module
angular.module('ReportIt.dashboard.controllers', ['ReportIt.dashboard.services']);
//the main app module
angular.module('ReportIt.dashboard', [
                                      'ReportIt.angular_loadmask',
                                      'ReportIt.validation',
                                      'ReportIt.dashboard.controllers',
                                      'ReportIt.shared',
                                      'ReportIt-directives',
                                      'ReportIt.security',
                                      'ui.select2']).
  config(["$httpProvider", "API_KEY", function(provider, apiKey) {
    provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
    provider.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';
    provider.defaults.headers.common['X-Application-API-Key'] = apiKey;
}]).
  run(['$rootScope', 'SharedScopeResponseHandling', 'Pagination', function($rootScope, SharedScopeResponseHandling, Pagination) {
    
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
  }]);