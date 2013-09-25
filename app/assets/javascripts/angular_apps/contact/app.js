//the services module
angular.module('ReportIt.contact.services', ['ReportIt.constants']);
//the controller module
angular.module('ReportIt.contact.controllers', ['ReportIt.contact.services']);
//the app module
angular.module('ReportIt.contact', [ 'ReportIt.angular_loadmask', 'ReportIt.validation', 'ReportIt.contact.controllers', 'ReportIt.shared' ]).
  config(["$httpProvider", function(provider) {
    provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
  }]);