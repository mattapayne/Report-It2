angular.module('ReportIt.register.services').
    service('RegisterService', ['$http', function($http) {
        this.register = function(registration) {
            return $http.post(ReportIt.routes.create_registration_path(), angular.toJson({ registration: registration }));
        };
}]);