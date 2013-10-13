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
}).directive('reportItTypeahead', ['$parse', '$compile', 'EMAIL_REGEX', function($parse, $compile, emailRegex) {
    return {
      restrict: 'E',
      replace: true,
      scope: {
        onSelect: '&',
        prefetchUrl: '=',
        remoteUrl: '='
      },
      template: "<input type='text' />",
      link: function(scope, element, attrs, ctrl) {
        
        var options = {
            
        };
        
        if (!angular.isUndefined(attrs.typeaheadName) && attrs.typeaheadName !== null) {
          options.name = attrs.typeaheadName;
        }
        
        if (!angular.isUndefined(attrs.prefetchUrl) && attrs.prefetchUrl !== null) {
          options.prefetch = scope.prefetchUrl;
        }
        
        if (!angular.isUndefined(attrs.remoteUrl) && attrs.remoteUrl !== null) {
          options.remote = scope.remoteUrl;
        }
        
        if (!angular.isUndefined(attrs.limit) && attrs.limit !== null) {
          options.limit = attrs.limit;
        }
        
        element.typeahead(options);
        
        element.on("keypress", function(e) {
          if(e.which === 13) {
            var value = element.val();
            if (emailRegex.test(value)) {
                scope.$apply(function() {
                var value = element.val();
                scope.onSelect({email: value});
                element.val("");
              });
            }
          }
        });
        
        element.on("typeahead:selected", function(evt, data) {
            scope.$apply(function() {
              var value = data.value;
              scope.onSelect({email: value});
              element.typeahead('setQuery', '');
            });
        });
        
        element.on("destroy", function() {
          element.typeahead('destroy');
        });
      }
    };
}]).directive('reportItDropZone', [function() {
  return {
    restrict: 'A',
    scope: {
      uploadUrl: '=',
      onComplete: '&'
    },
    link: function(scope, element, attrs) {
      Dropzone.autoDiscover = false
      var options = {
        url: scope.uploadUrl,
        maxFilesize: attrs.maxFilesize || 100,
        paramName: attrs.paramName || "file",
        maxThumbnailFilesize: attrs.maxThumbnailFilesize || 1,
        init: function() {
         if (scope.onComplete) {
            this.on('complete', function(file) {
              scope.$apply(function() {
                scope.onComplete();    
              });
              this.removeFile(file);
            });
          } 
        }
      };
      element.dropzone(options);
    }
  };
}]).directive('reportItTagsInput', [function() {
    return {
      restrict: 'E',
      scope: {
        tags: '=ngModel',
        remoteUrl: '='
      },
      replace: true,
      template: "<div class='report-it-tags-input'>" +
                  "<span class='report-it-tag label label-info' ng-repeat='tag in tags'>{{ tag }}" +
                    "<a class='report-it-tag-close' href='' ng-click='remove($index)'>&times;</a>" +
                  "</span>" +
                  "<div class='report-it-add-tag'>" +
                    "<input type='text' class='report-it-add-tag-input' ng-model='newTag' placeholder='Begin typing your tag here' />" +
                  "</div>" +
                "</div>",
      controller: function($scope, $attrs) {
        $scope.newTag = '';
        $scope.tags = $scope.tags || [];
      
        $scope.add = function() {
          var tag = $scope.newTag;
          $scope.tags.push(tag);
          $scope.newTag = '';
          $scope.$root.$broadcast('report:tag:added', tag);
        };
        
        $scope.remove = function(index) {
          var tag = $scope.tags.splice(index, 1);
          $scope.$root.$broadcast('report:tag:removed', tag);
        };
      },
      link: function(scope, element, attrs, ctrl) {
        var ENTER = 13;
        var inputElement = element.find('input.report-it-add-tag-input');
        
        inputElement.typeahead({
          remote: scope.remoteUrl
        });
        
        inputElement.on("typeahead:selected", function(evt, data) {
          scope.newTag = data.value;
          scope.add();
          scope.$apply(function() {
            inputElement.typeahead('setQuery', '');  
          });
        });
        
        inputElement.on("destroy", function() {
          inputElement.typeahead('destroy');
        });
        
        //handle enter key
        inputElement.on('keydown', function(e) {
          if(e.keyCode === ENTER) {
            scope.add();
            scope.$apply(function() {
              element.typeahead('setQuery', '');
            });
            e.preventDefault();
          }
        });
      }
    }
}]);