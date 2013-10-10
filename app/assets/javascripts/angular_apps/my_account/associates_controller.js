angular.module('ReportIt.my_account.controllers').controller('AssociatesController', ['$scope', 'MyAccountService',
  function($scope, MyAccountService) {
    
    var self = this;

    $scope.associates = [];
    $scope.pagination = null;
    $scope.currentPage = null;
    $scope.inviting = false;
    $scope.selectedEmails = [];
    $scope.invitationMessage = null;
    $scope.remoteUrl = MyAccountService.getPotentialAssociatesUrl();
    
    self.loadAssociates = function() {
      MyAccountService.getAssociates($scope.currentPage).
        success(function(response) {
          $scope.associates = response.associates;
          $scope.pagination = $scope.createPaginator(response);
        }).
        error(function(response) {
          $scope.setError(response.messages);
        });
    };
    
    self.loadAssociates();
    
    $scope.stopSharing = function(associate, report) {
      MyAccountService.stopSharing(associate, report).
        success(function(response) {
          $scope.setSuccess(response.messages);
          self.resetShares(associate, report);
        }).
        error(function(response) {
          $scope.setError(response.messages); 
        });
    };
    
    $scope.shouldDisplaySharingForAssociate = function(associate) {
      return associate.shares_visible;
    };
    
    $scope.hideReportSharingForAssociate = function(associate) {
      associate.shares_visible = false;
    };
    
    $scope.associateHasShares = function(associate) {
      if (associate.shares_visible && self.sharesExist(associate) && associate.shares.length > 0) {
        return true;
      }
      return false;
    };
    
    $scope.getReportShares = function(associate) {
      if (associate.shares_visible && self.sharesExist(associate)) {
        return associate.shares;
      }
      return [];
    };
    
    $scope.viewShares = function(associate) {
       if (self.sharesDoNotExist(associate)) {
          MyAccountService.getSharingForAssociate(associate).
            success(function(response) {
              associate.shares = response;
              associate.shares_visible = true;
            });
       }
       else {
        associate.shares_visible = true;
       }
    };
    
    $scope.addInvitee = function(email) {
      if ($scope.selectedEmails.indexOf(email) < 0) {
        $scope.selectedEmails.push(email);
      }
    };
    
    $scope.disassociate = function(associate) {
      MyAccountService.disassociate(associate).
        success(function(response) {
          self.loadAssociates();
          $scope.setSuccess(response.messages);
        }).
        error(function(response) {
          $scope.setError(response.messages);  
        });
    };
    
    $scope.invite = function() {
      if ($scope.selectedEmails !== null && $scope.selectedEmails.length > 0) {
        MyAccountService.sendInvitations($scope.invitationMessage, $scope.selectedEmails).
          success(function(response) {
            $scope.setSuccess(response.messages);
            //notify other scopes
            $scope.$parent.$broadcast('invitation:sent');
            $scope.stopInviting();
          }).
          error(function(response) {
            $scope.setError(response.messages);
          });
      }
    };
    
    $scope.removeInvitee = function(email) {
      var index = $scope.selectedEmails.indexOf(email);
      $scope.selectedEmails.splice(index, 1);
    };
    
    $scope.beginInviting = function() {
      $scope.inviting = true;
    };
    
    $scope.stopInviting = function() {
      $scope.inviting = false;
      $scope.selectedEmails = [];
      $scope.invitationMessage = null;
    };
    
    $scope.pageTo = function(page) {
      if (!angular.isUndefined(page) && page !== null && page !== $scope.currentPage) {
        $scope.currentPage = page;
        self.loadAssociates();
      }
    };
    
    self.resetShares = function(associate, report) {
      var index = -1;
      for (var i=0; i<associate.shares.length; i++) {
        if (report.id === associate.shares[i].id) {
          index = i;
          break;
        }
      }
      
      if (index >= 0) {
        associate.shares.splice(index, 1);
      }
    };
    
    self.sharesDoNotExist = function(associate) {
      return !self.sharesExist(associate);
    }
    
    self.sharesExist = function(associate) {
      return associate && !angular.isUndefined(associate.shares) && associate.shares !== null;
    };
}]);