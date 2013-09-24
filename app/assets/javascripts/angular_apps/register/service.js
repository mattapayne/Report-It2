angular.module('ReportIt.register.services').
    factory('RegisterService', ['$http', '$q', function($http, $q) {
        return {
                register: function(registration) {
                    return $http.post('/register', angular.toJson({ registration: registration }));
                }
            };  
}]);