angular.module('ReportIt.shared', []).
  factory('SharedScopeResponseHandling', function() {
      //Adds some common methods to the $scope object so they don't have to be implemented in every controller.
      return {
        addTo: function($scope) {
            
        //define a shared object
        var SharedMethods = function() {
            
            var self = this;
            self.SUCCESS = 1;
            self.ERROR = 2;
            self.NONE = 3;
            self.result = { type: self.NONE, messages: null };
            
            self.hasResult = function() {
              return self.result.type !== self.NONE;
            };
            
            self.resetResult = function() {
              self.result = { type: self.NONE, messages: null };
            };
            
            self.resultIsError = function() {
              return self.result.type === self.ERROR;
            };
            
            self.resultIsSuccess = function() {
              return self.result.type === self.SUCCESS;
            };
            
            self.resultClasses = function() {
              var classes = '';
              if(self.result.type === self.NONE) {
                return classes;
              }
              classes = 'alert';
              classes += self.result.type === self.ERROR ? ' alert-danger' : ' alert-success';
              return classes;
            };
            
            self.setError = function(messages) {
              self.result.type = self.ERROR;
              self.result.messages = messages;
            };
            
            self.setSuccess = function(messages) {
              self.result.type = self.SUCCESS;
              self.result.messages = messages;
            };
            
            self.clearResult = function() {
              self.result = { type: self.NONE, messages: null };
            };
            
            self.getMessages = function() {
              return self.result.messages;
            }
          };
          
          $scope = angular.extend($scope, new SharedMethods());
        }
      };
  });