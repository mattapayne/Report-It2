angular.module('ReportIt.shared', []).
  service('SharedScopeResponseHandling', function() {
    //Adds some common methods to the $scope object so they don't have to be implemented in every controller.
    this.mixin = function($scope) {
        $scope.SUCCESS = 1;
        $scope.ERROR = 2;
        $scope.NONE = 3;
        $scope.result = { type: $scope.NONE, messages: null };
        
        $scope.hasResult = function() {
          return $scope.result.type !== $scope.NONE;
        };
        
        $scope.resetResult = function() {
          $scope.result = { type: $scope.NONE, messages: null };
        };
        
        $scope.resultIsError = function() {
          return $scope.result.type === $scope.ERROR;
        };
        
        $scope.resultIsSuccess = function() {
          return $scope.result.type === $scope.SUCCESS;
        };
        
        $scope.resultClasses = function() {
          var classes = '';
          if($scope.result.type === $scope.NONE) {
            return classes;
          }
          classes = 'alert';
          classes += $scope.result.type === $scope.ERROR ? ' alert-danger' : ' alert-success';
          return classes;
        };
        
        $scope.setError = function(messages) {
          $scope.result.type = $scope.ERROR;
          $scope.result.messages = messages;
        };
        
        $scope.setSuccess = function(messages) {
          $scope.result.type = $scope.SUCCESS;
          $scope.result.messages = messages;
        };
        
        $scope.clearResult = function() {
          $scope.result = { type: $scope.NONE, messages: null };
        };
        
        $scope.getMessages = function() {
          return $scope.result.messages;
        };
      };
  }).
  service("Pagination", function() {
    this.Paginator = function(args) {
      var self = this;
      
      args = args || {};
      
      var defaults = {
        current: 1,
        total: 1,
        has_next: false,
        has_previous: false,
        per_page: 10
      };
      
      var opts = $.extend(defaults, args);
      
      self.current = parseInt(opts.current);
      self.total = parseInt(opts.total);
      self.has_next = opts.has_next;
      self.has_previous = opts.has_previous;
      self.per_page = parseInt(opts.per_page);
      self.visible = self.total > 1;
      self.pageNumbers = [];

      var pageNumber = function(name, isCurrent) {
        var page = this;
        page.name = name;
        page.isCurrent = isCurrent;
        page.cssClasses = isCurrent ? ['active', 'disabled'] : '';
      };
    
      for (var i = 1; i<= self.total; i++) {
        self.pageNumbers.push(new pageNumber(i.toString(), i == self.current));
      }
    }
});