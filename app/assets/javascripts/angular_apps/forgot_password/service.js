angular.module('ReportIt.forgot_password.services').
    service('ForgotPasswordService', ['$http', function($http) {
        this.changePassword = function(model) {
            return $http.post(ReportIt.routes.create_forgot_password_request_path(), angular.toJson({ password_reset_request: model }));
        };
}]);