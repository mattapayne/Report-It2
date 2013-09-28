//the services module
angular.module('ReportIt.report_template.services', ['ReportIt.constants']);
//the controllers module
angular.module('ReportIt.report_template.controllers', ['ReportIt.report_template.services', 'ReportIt.constants']);
//the app module
angular.module('ReportIt.report_template', [
                                            'ReportIt.angular_loadmask',
                                            'ReportIt.validation',
                                            'ReportIt.report_template.controllers',
                                            'ReportIt-redactor',
                                            'ReportIt.shared',
                                            'ngSanitize',
                                            'bsTagsInput',
                                            'ui.select2']).
  config(["$httpProvider", '$sceProvider', function($httpProvider, $sceProvider) {
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
    $sceProvider.enabled(false);
  }]);