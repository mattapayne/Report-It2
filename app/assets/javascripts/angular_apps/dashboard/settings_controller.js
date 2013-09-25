angular.module('ReportIt.dashboard.controllers').controller('SettingsController', ['$scope', 'DashboardService', 'INTEGER_REGEX', 'SharedScopeResponseHandling',
  function($scope, DashboardService, integerRegex, SharedScopeResponseHandling) {
    
    var self = this;
    SharedScopeResponseHandling.mixin($scope);
    $scope.settingsBeingEdited = {};
    $scope.settings = [];
    
    DashboardService.getSettings().success(function(settings) {
       $scope.settings = settings; 
    });
    
    $scope.valueIsValid = function(index) {
        var setting = $scope.settings[index];
        if (setting.validation_rule) {
            switch (setting.validation_rule) {
                case 'MustBeInteger':
                    if (integerRegex.test(setting.value) == false) {
                        return false;
                    }
            }
        }
        return true;
    };
    
    $scope.edit = function(index) {
        self.backupSetting(index);
    };
    
    $scope.editing = function(index) {
        return index in $scope.settingsBeingEdited;
    };
    
    $scope.editingAny = function() {
        return !_.isEmpty($scope.settingsBeingEdited);
    };
    
    $scope.stopEditing = function(index) {
        delete $scope.settingsBeingEdited[index];
    };
    
    $scope.cancelEditing = function(index) {
        var original = $scope.settingsBeingEdited[index];
        $scope.settings[index] = angular.copy(original);
        delete $scope.settingsBeingEdited[index];
    };
    
    $scope.update = function(index) {
        var setting = $scope.settings[index];
        DashboardService.updateSetting(setting).
          success(function(response) {
            $scope.stopEditing(index);
            $scope.setSuccess(response.messages);
        }).error(function(response) {
            var original = $scope.settingsBeingEdited[index];
            $scope.settings[index] = angular.copy(original);
            $scope.setError(response.messages);
        });
    };

    self.backupSetting = function(index) {
        var organization = $scope.settings[index];
        $scope.settingsBeingEdited[index] = angular.copy(organization);
    };
  }
]);