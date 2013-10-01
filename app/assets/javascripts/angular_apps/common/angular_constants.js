//bootstrap Angular
angular.module('ReportIt.constants', []).
  constant('EMAIL_REGEX', /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/).
  constant('INTEGER_REGEX', /^\-?\d*$/);