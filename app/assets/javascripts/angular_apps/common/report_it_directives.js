angular.module('ReportIt-directives', []).
  directive('tooltip', ['$parse', '$compile', function($parse, $compile) {
  return {
    restrict: 'A',
    scope: true,
    link: function(scope, element, attrs, ctrl) {

      //parse the expression passed in
      var getter = $parse(attrs.tooltip),
        setter = getter.assign,
        value = getter(scope);
        
      var title = attrs.tooltipTitle;

      // Watch tooltip for changes
      scope.$watch(attrs.tooltip, function(newValue, oldValue) {
        value = newValue;
      });
      
      element.tooltip({
        title: function() {
            var text = angular.isFunction(value) ? value.apply(null, arguments) : value;
            return title + "<br />" + text;
          },
        html: true
      });
    }
  };
}]).directive('reportItEnter', function () {
    return function (scope, element, attrs) {
        element.bind("keydown keypress", function (event) {
            if(event.which === 13) {
                scope.$apply(function (){
                    scope.$eval(attrs.reportItEnter);
                });

                event.preventDefault();
            }
        });
    };
});