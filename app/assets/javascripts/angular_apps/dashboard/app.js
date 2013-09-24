//services module
angular.module('ReportIt.dashboard.services', []);
//controllers module
angular.module('ReportIt.dashboard.controllers', ['ReportIt.dashboard.services', 'ReportIt.constants', 'angular-redactor']);
//the main app module
angular.module('ReportIt.dashboard', [ 'ReportIt.angular_loadmask', 'ReportIt.validation', 'ReportIt.dashboard.controllers' ]).
  config(["$httpProvider", function(provider) {
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
}]);