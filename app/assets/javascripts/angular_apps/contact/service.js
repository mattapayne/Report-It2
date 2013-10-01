angular.module('ReportIt.contact.services').
    service('MessageService', ['$http', function($http) {
        this.sendMessage = function(message) {
            return $http.post(ReportIt.routes.create_message_path(), angular.toJson({ message: message }));
        };
}]);