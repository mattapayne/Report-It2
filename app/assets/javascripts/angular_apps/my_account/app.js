//services module
angular.module('ReportIt.my_account.services', ['ReportIt.constants']);
//controllers module
angular.module('ReportIt.my_account.controllers', ['ReportIt.my_account.services']);
//the main app module
angular.module('ReportIt.my_account', [
                                      'ReportIt.angular_loadmask',
                                      'ReportIt.validation',
                                      'ReportIt.my_account.controllers',
                                      'ReportIt.shared',
                                      'ReportIt-redactor',
                                      'ReportIt-directives',
                                      'ReportIt.security',
                                      'ui.select2']).
  config(["$httpProvider", "$sceProvider", function(provider, $sceProvider) {
    provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
    provider.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';
    provider.defaults.headers.common['X-Application-API-Key'] = '91c65d6d8a3507dbba06167d4dc32c16';
    $sceProvider.enabled(false);
}]);