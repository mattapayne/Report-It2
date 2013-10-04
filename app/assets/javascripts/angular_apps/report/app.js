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
                                    'bsTagsInput']).
  config(["$httpProvider", '$sceProvider', function($httpProvider, $sceProvider) {
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
    $httpProvider.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';
    $httpProvider.defaults.headers.common['X-Application-API-Key'] = '91c65d6d8a3507dbba06167d4dc32c16';
    $sceProvider.enabled(false);
  }]);