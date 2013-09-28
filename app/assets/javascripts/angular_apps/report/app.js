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
                                            'localytics.directives']).
  config(["$httpProvider", function(provider) {
    provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
  }]);