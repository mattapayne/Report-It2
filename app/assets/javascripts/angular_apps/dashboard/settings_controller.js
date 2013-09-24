angular.module('ReportIt.dashboard.controllers').controller('SettingsController', ['$scope', 'DashboardService', 'INTEGER_REGEX',
  function($scope, DashboardService, integerRegex) {
    var self = this;
    var SUCCESS = 1;
    var ERROR = 2;
    var NONE = 3;
    
    $scope.settingsBeingEdited = {};
    $scope.settings = [];
    $scope.result = {type: NONE, value: null};
    
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
        DashboardService.updateSetting(setting).success(function(responseJson) {
            $scope.stopEditing(index);
            $scope.result.type = SUCCESS;
            $scope.result.value = responseJson.messages;
        }).error(function(responseJson) {
            var original = $scope.settingsBeingEdited[index];
            $scope.settings[index] = angular.copy(original);
            $scope.result.type = ERROR;
            $scope.result.value = responseJson.messages;
        });
    };

    self.backupSetting = function(index) {
        var organization = $scope.settings[index];
        $scope.settingsBeingEdited[index] = angular.copy(organization);
    };
  }
]);