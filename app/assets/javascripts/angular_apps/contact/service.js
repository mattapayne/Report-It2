angular.module('ReportIt.contact.services', []).
    factory('MessageService', ['$http', '$q', function($http, $q) {
        return {
                sendMessage: function(message) {
                    return $http.post('/message', angular.toJson({ message: message }));
                }
            };  
}]);