angular.module('ReportIt.forgot_password.services').
    factory('ForgotPasswordService', ['$http', '$q', function($http, $q) {
        return {
                changePassword: function(model) {
                    return $http.post('/forgot_password', angular.toJson({ password_reset_request: model }));
                }
            };  
}]);