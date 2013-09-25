//the services module
angular.module('ReportIt.register.services', []);
//the controllers module
angular.module('ReportIt.register.controllers', ['ReportIt.register.services']);
//the app module
angular.module('ReportIt.register', [ 'ReportIt.angular_loadmask', 'ReportIt.validation', 'ReportIt.register.controllers', 'ReportIt.shared' ]).
  config(["$httpProvider", function(provider) {
    provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
  }]);