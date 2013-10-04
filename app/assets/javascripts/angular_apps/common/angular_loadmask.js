/* Angular interceptor that hooks up jQuery LoadMask
 * and show/hides it when there are ajax things going on
 */

(function() {

'use strict';

angular.module('ReportIt.angular_loadmask', [])
  .config(['$httpProvider', function ($httpProvider) {

    var interceptor = ['$q', 'loadMask', function ($q, loadMask) {

      var reqsTotal = 0;
      var reqsCompleted = 0;

      function setComplete() {
        loadMask.unmask();
        reqsCompleted = 0;
        reqsTotal = 0;
      }

      return {
        'request': function(config) {
          if (reqsTotal === 0) {
            loadMask.mask();
          }
          reqsTotal++;
          return config || $q.when(config);
        },

        'response': function(response) {
          reqsCompleted++;
          if (reqsCompleted === reqsTotal) {
            setComplete();
          } 
          return response || $q.when(response);
        },

        'responseError': function(rejection) {
          reqsCompleted++;
          if (reqsCompleted === reqsTotal) {
            setComplete();
          } 
          return $q.reject(rejection);
        }
      };
    }];

    $httpProvider.interceptors.push(interceptor);
  }]).provider('loadMask', function() {

    this.$get = ['$document', function ($document, $animate) {

      var body = $document.find('body');
      
      function _mask() {
        $(body).mask("Loading ...");
      }
      
      function _unmask() {
        $(body).unmask();
      }

      return {
        mask: _mask,
        unmask: _unmask
      };
    }];     
  });       
})();
