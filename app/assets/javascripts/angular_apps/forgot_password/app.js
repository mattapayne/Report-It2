//services module
angular.module('ReportIt.forgot_password.services', []);
//controllers module
angular.module('ReportIt.forgot_password.controllers', ['ReportIt.forgot_password.services']);
//the app module
angular.module('ReportIt.forgot_password', [ 'ReportIt.angular_loadmask', 'ReportIt.validation', 'ReportIt.forgot_password.controllers' ]);