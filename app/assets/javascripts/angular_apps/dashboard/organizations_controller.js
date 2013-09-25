angular.module('ReportIt.dashboard.controllers').controller('OrganizationsController', ['$scope', 'DashboardService', 'SharedScopeResponseHandling',
  function($scope, DashboardService, SharedScopeResponseHandling) {
    
    var self = this;
    SharedScopeResponseHandling.addTo($scope);
    $scope.organizationsBeingEdited = {};
    $scope.organizationsBeingDeleted = [];
    $scope.adding = false;
    $scope.organizationName = "";
    $scope.organizations = [];
    
    DashboardService.getOrganizations().success(function(organizations) {
       $scope.organizations = organizations; 
    });
    
    $scope.newOrganizationIsValid = function() {
      return $scope.organizationName && $scope.organizationName != '';
    };
    
    $scope.organizationIsValid = function(index) {
        var organization = $scope.organizations[index];
        return organization.name && organization.name != '';
    };
    
    $scope.edit = function(index) {
        self.backupOrganization(index);
    };
    
    $scope.editing = function(index) {
        return index in $scope.organizationsBeingEdited;
    };
    
    $scope.deleting = function(index) {
        return _.contains($scope.organizationsBeingDeleted, index);
    };
    
    $scope.editingAny = function() {
        return !_.isEmpty($scope.organizationsBeingEdited);
    };
    
    $scope.stopEditing = function(index) {
        delete $scope.organizationsBeingEdited[index];
    };
    
    $scope.cancelEditing = function(index) {
        var original = $scope.organizationsBeingEdited[index];
        $scope.organizations[index] = angular.copy(original);
        delete $scope.organizationsBeingEdited[index];
    };
    
    $scope.update = function(index) {
        var organization = $scope.organizations[index];
        DashboardService.updateOrganization(organization).
          success(function(response) {
            $scope.stopEditing(index);
            $scope.setSuccess(response.messages);
        }).error(function(response) {
            var original = $scope.organizationsBeingEdited[index];
            $scope.organizations[index] = angular.copy(original);
            $scope.setError(response.messages);
        });
    };
   
    $scope.destroy = function(index) {
        var organization = $scope.organizations[index];
        if (confirm("Are you sure?")) {
            $scope.organizationsBeingDeleted.push(index);
            self.deleteOrganization(index, organization);
        }
    };
    
    $scope.startAdd = function() {
        $scope.adding = true;
    };
    
    $scope.stopAdd = function() {
        $scope.organizationName = "";
        $scope.adding = false;
    };
    
    $scope.create = function() {
        var organization = { name: $scope.organizationName };
        DashboardService.createOrganization(organization).
          success(function(response) {
            $scope.organizations.push(response.organization);
            $scope.stopAdd();
            $scope.setSuccess(response.messages);
        }).error(function(response) {
            $scope.setError(response.messages);
        });
    };
  
    self.backupOrganization = function(index) {
        var organization = $scope.organizations[index];
        $scope.organizationsBeingEdited[index] = angular.copy(organization);
    };
    
    self.stopManagingOrganization = function(index) {
        $scope.organizationsBeingDeleted =
                _.reject($scope.organizationsBeingDeleted, function(num) {
                    return num === index
            });
    };
    
    //since there is no 'finally' construct in Angular's promise returned by $http, we have to duplicate some code.
    self.deleteOrganization = function(index, organization) {
        DashboardService.destroyOrganization(organization).
          success(function(response) {
              $scope.organizations.splice(index, 1);
              self.stopManagingOrganization(index);
              $scope.setSuccess(response.messages);
          }).error(function(response) {
                self.stopManagingOrganization(index);
                $scope.setError(response.messages);
            });
      };          
    }
]);