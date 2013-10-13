//bootstrap Angular
angular.module('ReportIt.constants', []).
  constant('EMAIL_REGEX', /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/).
  constant('INTEGER_REGEX', /^\-?\d*$/).
  constant("API_KEY", "91c65d6d8a3507dbba06167d4dc32c16");