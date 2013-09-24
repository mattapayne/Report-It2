//the services module
angular.module('ReportIt.contact.services', []);
//the controller module
angular.module('ReportIt.contact.controllers', ['ReportIt.contact.services']);
//the app module
angular.module('ReportIt.contact', [ 'ReportIt.angular_loadmask', 'ReportIt.validation', 'ReportIt.contact.controllers' ]);