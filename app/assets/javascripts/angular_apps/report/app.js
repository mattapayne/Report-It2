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
                                            'ngSanitize',
                                            'bsTagsInput',
                                            'ui.select2']).
  config(["$httpProvider", '$sceProvider', function($httpProvider, $sceProvider) {
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
    $sceProvider.enabled(false);
  }]);