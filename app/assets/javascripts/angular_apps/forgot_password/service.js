angular.module('ReportIt.forgot_password.services').
    service('ForgotPasswordService', ['$http', '$q', 'FORGOT_PASSWORD_URLS', function($http, $q, FORGOT_PASSWORD_URLS) {
        this.changePassword = function(model) {
            return $http.post(FORGOT_PASSWORD_URLS.create_forgot_password_request_url, angular.toJson({ password_reset_request: model }));
        };
}]);