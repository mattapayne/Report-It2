//the services module
angular.module('ReportIt.register.services', []);
//the controllers module
angular.module('ReportIt.register.controllers', ['ReportIt.register.services']);
//the app module
angular.module('ReportIt.register', [ 'ReportIt.angular_loadmask', 'ReportIt.validation', 'ReportIt.register.controllers' ]);