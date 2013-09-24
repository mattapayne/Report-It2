angular.module('ReportIt.validation', ['ReportIt.constants']).
  directive('mustBeInteger', 'INTEGER_REGEX', [function(integerRegex) {
    return {
      require: 'ngModel',
      link: function(scope, elm, attrs, ctrl) {
        ctrl.$parsers.unshift(function(viewValue) {
          if (integerRegex.test(viewValue)) {
            ctrl.$setValidity('mustBeInteger', true);
            return viewValue;
          }
          else {
            ctrl.$setValidity('mustBeInteger', false);
            return undefined;
          }
        });
      }
  }
  }]).
  directive('mustBeEmail', ['EMAIL_REGEX', function(emailRegex) {
    return {
      require: 'ngModel',
      link: function(scope, elm, attrs, ctrl) {
        ctrl.$parsers.unshift(function(viewValue) {
          if (emailRegex.test(viewValue)) {
            ctrl.$setValidity('mustBeEmail', true);
            return viewValue;
          }
          else {
            ctrl.$setValidity('mustBeEmail', false);
            return undefined;
          }
        });
      }
    }
  }]).directive('match', ['$parse', function($parse) {
  return {
    require: 'ngModel',
    link: function(scope, elem, attrs, ctrl) {
      //ctrl is the form object
      scope.$watch(function() {
        var matchTo = $parse(attrs.match)(scope);
        var value = ctrl.$modelValue;
        return matchTo === value;
      }, function(currentValue) {
        ctrl.$setValidity('mismatch', currentValue);
      });
    }
  };
}]);