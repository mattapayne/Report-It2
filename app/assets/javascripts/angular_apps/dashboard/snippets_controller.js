angular.module('ReportIt.dashboard.controllers').controller('SnippetsController', ['$scope', 'DashboardService',
  function($scope, DashboardService) {
    var self = this;
    var SUCCESS = 1;
    var ERROR = 2;
    var NONE = 3;
    
    $scope.adding = false;
    $scope.snippetsBeingEdited = {};
    $scope.snippetsBeingDeleted = [];
    $scope.snippetName = "";
    $scope.snippetContent = "";
    $scope.snippets = [];
    $scope.result = {type: NONE, value: null};
    
    $scope.redactorOptions = {
        linebreaks: true,
        paragraphy: false,
        minHeight: 200,
        plugins: ['fontsize', 'fontfamily', 'fontcolor']
    };
    
    DashboardService.getSnippets().success(function(snippets) {
       $scope.snippets = snippets; 
    });
    
    $scope.resetResult = function() {
      $scope.result = {type: NONE, value: null};
    };
    
    $scope.getAlertClasses = function() {
      var classes = '';
      if($scope.result.type === NONE) {
        return classes;
      }
      classes = 'alert fade in';
      classes += $scope.result.type === ERROR ? ' alert-danger' : ' alert-success';
      return classes;
    };
    
    $scope.hasResult = function() {
      return $scope.result.type !== NONE;
    };
    
    $scope.newSnippetIsValid = function() {
      return $scope.snippetName && $scope.snippetContent && $scope.snippetName != '' && $scope.snippetContent != '';  
    };
    
    $scope.snippetIsValid = function(index) {
      var snippet = $scope.snippets[index];
      return snippet.name && snippet.content && snippet.name != '' && snippet.content != '';  
    };
    
    $scope.edit = function(index) {
        self.backupSnippet(index);
    };
    
    $scope.editing = function(index) {
        return index in $scope.snippetsBeingEdited;
    };
    
    $scope.deleting = function(index) {
        return _.contains($scope.snippetsBeingDeleted, index);
    };
    
    $scope.editingAny = function() {
        return !_.isEmpty($scope.snippetsBeingEdited);
    };
    
    $scope.stopEditing = function(index) {
       delete $scope.snippetsBeingEdited[index];
    };
    
    $scope.cancelEditing = function(index) {
        var original = $scope.snippetsBeingEdited[index];
        $scope.snippets[index] = angular.copy(original);
        delete $scope.snippetsBeingEdited[index];
    };
    
    $scope.update = function(index) {
        var snippet = $scope.snippets[index];
        DashboardService.updateSnippet(snippet).success(function(jsonResponse) {
            $scope.stopEditing(index);
            $scope.result.type = SUCCESS;
            $scope.result.value = jsonResponse.messages;
        }).error(function(jsonResponse) {
            var original = $scope.snippetsBeingEdited[index];
            $scope.snippets[index] = angular.copy(original);
            $scope.result.type = ERROR;
            $scope.result.value = jsonResponse.messages;
        });
    };
   
    $scope.destroy = function(index) {
        var snippet = $scope.snippets[index];
        if (confirm("Are you sure?")) {
            $scope.snippetsBeingDeleted.push(index);
            self.deleteSnippet(index, snippet);
        }
    };
    
    $scope.startAdd = function() {
        $scope.adding = true;
    };
    
    $scope.stopAdd = function() {
        $scope.snippetName = "";
        $scope.snippetContent = "";
        $scope.adding = false;
    };
    
    $scope.create = function() {
        var snippet = { name: $scope.snippetName, content: $scope.snippetContent };
        DashboardService.createSnippet(snippet).success(function(jsonResponse) {
            $scope.snippets.push(jsonResponse.snippet);
            $scope.stopAdd();
            $scope.result.type = SUCCESS;
            $scope.result.value = jsonResponse.messages;
        }).error(function(jsonResponse) {
            $scope.result.type = ERROR;
            $scope.result.value = jsonResponse.messages;
        });
    };
    
    self.backupSnippet = function(index) {
        var snippet = $scope.snippets[index];
        $scope.snippetsBeingEdited[index] = angular.copy(snippet);
    };
    
    self.stopManagingSnippet = function(index) {
        $scope.snippetsBeingDeleted =
                    _.reject($scope.snippetsBeingDeleted, function(num) {
                        return num === index
                });
    };
    
    //since there is no 'finally' construct in Angular's promise returned by $http, we have to duplicate some code.
    self.deleteSnippet = function(index, snippet) {
        DashboardService.destroySnippet(snippet).success(function(jsonResponse) {
                $scope.snippets.splice(index, 1);
                self.stopManagingSnippet(index);
                $scope.result.type = SUCCESS;
                $scope.result.value = jsonResponse.messages;
            }).error(function(jsonResponse) {
                self.stopManagingSnippet(index);
                $scope.result.type = ERROR;
                $scope.result.value = jsonResponse.messages;
            });
    };
  }
]);