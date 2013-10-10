//the services module
angular.module('ReportIt.register.services', ['ReportIt.constants']);
//the controllers module
angular.module('ReportIt.register.controllers', ['ReportIt.register.services']);
//the app module
angular.module('ReportIt.register', [
                                     'ReportIt.angular_loadmask',
                                     'ReportIt.validation',
                                     'ReportIt.register.controllers',
                                     'ReportIt.shared' ]).
  config(["$httpProvider", function(provider) {
    provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
    provider.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';
  }]).run(['$rootScope', 'SharedScopeResponseHandling', function($rootScope, SharedScopeResponseHandling) {
    $rootScope.mixinCommonFunctionality = function(scope) {
      SharedScopeResponseHandling.mixin(scope);
    };
  }]);