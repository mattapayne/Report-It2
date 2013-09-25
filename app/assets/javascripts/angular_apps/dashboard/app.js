//services module
angular.module('ReportIt.dashboard.services', []);
//controllers module
angular.module('ReportIt.dashboard.controllers', ['ReportIt.dashboard.services', 'ReportIt.constants']);
//the main app module
angular.module('ReportIt.dashboard', [
                                      'ReportIt.angular_loadmask',
                                      'ReportIt.validation',
                                      'ReportIt.dashboard.controllers',
                                      'ReportIt.shared',
                                      'ReportIt-redactor',
                                      'ReportIt-tooltip']).
  config(["$httpProvider", function(provider) {
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
}]);