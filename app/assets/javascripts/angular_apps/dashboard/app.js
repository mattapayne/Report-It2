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
  config(["$httpProvider", function(provider) {
    provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
    provider.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';
    provider.defaults.headers.common['X-Application-API-Key'] = '91c65d6d8a3507dbba06167d4dc32c16';
}]).
  run(['$rootScope', 'SharedScopeResponseHandling', 'Pagination', function($rootScope, SharedScopeResponseHandling, Pagination) {
    
    //inject some common functionality into the root scope.
    SharedScopeResponseHandling.mixin($rootScope);
    
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