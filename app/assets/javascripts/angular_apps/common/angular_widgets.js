angular.module('ReportIt-widgets', [])
  .directive("reportItChosen", [function () {
    var linker = function(scope,element,attrs) {
        var list = attrs['chosen'];

        scope.$watch(list, function(){
            element.trigger('liszt:updated');
            element.trigger("chosen:updated");
        });

        element.chosen({
          allow_single_deselect: true
        });
    };

    return {
        restrict:'A',
        link: linker
    }
  }]);