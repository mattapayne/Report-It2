angular.module('ReportIt.register.services').
    service('RegisterService', ['$http', '$q', 'REGISTER_URLS', function($http, $q, REGISTER_URLS) {
        this.register = function(registration) {
            return $http.post(REGISTER_URLS.create_registration_url, angular.toJson({ registration: registration }));
        };
}]);