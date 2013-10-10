angular.module('ReportIt.my_account.controllers').controller('SettingsController', ['$scope', 'MyAccountService', 'INTEGER_REGEX',
  function($scope, MyAccountService, integerRegex) {
    
    var self = this;
    
    $scope.mixinCommonFunctionality($scope);

    $scope.settingsBeingEdited = {};
    $scope.settings = [];
    
    MyAccountService.getSettings().
      success(function(settings) {
        $scope.settings = settings; 
      }).
      error(function(response) {
        $scope.setError(response.messages);  
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
        MyAccountService.updateSetting(setting).
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