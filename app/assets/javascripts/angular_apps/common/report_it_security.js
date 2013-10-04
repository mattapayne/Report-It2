angular.module('ReportIt.security', [])
  .config(['$httpProvider', function ($httpProvider) {

    var interceptor = ['$q', '$window', function ($q, $window) {

      return {
        'request': function(config) {
          return config || $q.when(config);
        },

        'response': function(response) {
          return response || $q.when(response);
        },

        'responseError': function(rejection) {
          if (rejection.status === 401) {
            $window.location.href = rejection.data.redirect;
            return;
          }
          return $q.reject(rejection);
        }
      };
    }];

    $httpProvider.interceptors.push(interceptor);
  }])