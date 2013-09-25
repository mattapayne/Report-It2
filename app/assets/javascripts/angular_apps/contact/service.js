angular.module('ReportIt.contact.services').
    service('MessageService', ['$http', '$q', 'CONTACT_URLS', function($http, $q, CONTACT_URLS) {
        this.sendMessage = function(message) {
            return $http.post(CONTACT_URLS.create_message_url, angular.toJson({ message: message }));
        };
}]);