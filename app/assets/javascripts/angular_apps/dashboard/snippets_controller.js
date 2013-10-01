angular.module('ReportIt.dashboard.controllers').controller('SnippetsController',
  ['$scope', 'DashboardService', 'SharedScopeResponseHandling',
  function($scope, DashboardService, SharedScopeResponseHandling) {
    
    var self = this;
    SharedScopeResponseHandling.mixin($scope);
    $scope.adding = false;
    $scope.snippetsBeingEdited = {};
    $scope.snippetsBeingDeleted = [];
    $scope.snippetName = "";
    $scope.snippetContent = "";
    $scope.snippets = [];
    
    $scope.redactorOptions = {
        linebreaks: true,
        paragraphy: false,
        minHeight: 200,
        imageUpload : ReportIt.routes.api_v1_image_upload_path(),
        clipboardUploadUrl: ReportIt.routes.api_v1_image_upload_path(),
        plugins: ['fontsize', 'fontfamily', 'fontcolor']
    };
    
    DashboardService.getSnippets().success(function(snippets) {
       $scope.snippets = snippets; 
    });
    
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
        DashboardService.updateSnippet(snippet).
          success(function(response) {
            $scope.stopEditing(index);
            $scope.setSuccess(response.messages);
        }).error(function(response) {
            var original = $scope.snippetsBeingEdited[index];
            $scope.snippets[index] = angular.copy(original);
            $scope.setError(response.messages);
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
        DashboardService.createSnippet(snippet).
          success(function(response) {
            $scope.snippets.push(response.snippet);
            $scope.stopAdd();
            $scope.setSuccess(response.messages);
        }).error(function(response) {
            $scope.setError(response.messages);
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
        DashboardService.destroySnippet(snippet).
            success(function(response) {
                $scope.snippets.splice(index, 1);
                self.stopManagingSnippet(index);
                $scope.setSuccess(response.messages);
            }).error(function(response) {
                self.stopManagingSnippet(index);
                $scope.setError(response.messages);
            });
    };
  }
]);