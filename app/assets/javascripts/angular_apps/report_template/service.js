angular.module('ReportIt.report_template.services').
    service('ReportTemplateService', ['$http', '$q', 'REPORT_TEMPLATE_URLS',
        function($http, $q, REPORT_TEMPLATE_URLS) {
        this.get = function(reportTemplateId) {
            if (reportTemplateId) {
                return $http.get(REPORT_TEMPLATE_URLS.get_report_template_url + reportTemplateId);  
            }
            //because we are creating a new ReportTemplate, there is no need to hit the backend.
            //just return a promise that resolves to a new object.
            var deferred = $q.defer();
            deferred.resolve({name: '', description: '', content: '', organization_ids: [], id: ''});
            var promise = deferred.promise;
            promise.success = function(fn) {
                promise.then(function(response) {
                    fn(response);
                });
            };
            return promise;
        };
        
        this.save = function(reportTemplate) {
            if (reportTemplate.id) {
                return $http.put(REPORT_TEMPLATE_URLS.update_report_template_url + reportTemplate.id, angular.toJson( { report_template: reportTemplate }));
            }
            return $http.post(REPORT_TEMPLATE_URLS.create_report_template_url, angular.toJson({ report_template: reportTemplate }));
        };
        
        this.getOrganizations = function() {
            return $http.get(REPORT_TEMPLATE_URLS.get_organizations_url);    
        };
                
        this.getSnippets = function() {
            return $http.get(REPORT_TEMPLATE_URLS.get_snippets_url);
        };
}]);