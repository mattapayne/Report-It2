//the services module
angular.module('ReportIt.report.services', ['ReportIt.constants']);
//the controllers module
angular.module('ReportIt.report.controllers', ['ReportIt.report.services', 'ReportIt.constants']);
//the app module
angular.module('ReportIt.report', [
                                    'ReportIt.angular_loadmask',
                                    'ReportIt.validation',
                                    'ReportIt.report.controllers',
                                    'ReportIt-redactor',
                                    'ReportIt.shared',
                                    'ReportIt.security',
                                    'ngSanitize',
                                    'ReportIt-directives']).
  config(["$httpProvider", '$sceProvider', 'API_KEY', function($httpProvider, $sceProvider, apiKey) {
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
    $httpProvider.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';
    $httpProvider.defaults.headers.common['X-Application-API-Key'] = apiKey;
    $sceProvider.enabled(false);
  }]).run(['$rootScope', 'SharedScopeResponseHandling', function($rootScope, SharedScopeResponseHandling) {
    $rootScope.mixinCommonFunctionality = function(scope) {
      SharedScopeResponseHandling.mixin(scope);
    };
  }]);