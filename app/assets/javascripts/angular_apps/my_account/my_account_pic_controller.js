angular.module('ReportIt.my_account.controllers').controller('MyAccountPicController', ['$scope', 'MyAccountService',
  function($scope, MyAccountService) {
    
  var self = this;
  self.buttonTextMap = {
    visible: 'Cancel Upload',
    hidden: 'Upload a New Image'
  };
  
  $scope.mixinCommonFunctionality($scope);
  
  $scope.profilePicUploadUrl = MyAccountService.myProfilePicUploadUrl();
  $scope.profilePicUrl = null;
  $scope.uploadNewPic = false;
  $scope.buttonText = self.buttonTextMap.hidden;
  
  self.loadProfilePic = function() {
    MyAccountService.getProfilePic().
      success(function(response) {
        $scope.profilePicUrl = response.url;
      }).
      error(function(response) {
        $scope.setError(response.message);
      });  
  };
  
  $scope.updateProfilePic = function() {
    self.loadProfilePic();
    $scope.toggleImageUpload();
  };
  
  $scope.$watch('uploadNewPic', function(oldValue, newValue) {
    if($scope.uploadNewPic === true) {
      $scope.buttonText = self.buttonTextMap.visible;
    }
    else {
      $scope.buttonText = self.buttonTextMap.hidden;
    }
  });
  
  self.loadProfilePic();
  
  $scope.hasProfilePicture = function() {
    return $scope.profilePicUrl !== null;
  };
  
  $scope.toggleImageUpload = function() {
    $scope.uploadNewPic = !$scope.uploadNewPic;
  };
  
}]);