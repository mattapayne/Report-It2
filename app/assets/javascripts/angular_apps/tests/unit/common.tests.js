'use strict';

describe("Constants", function() {
  
  beforeEach(angular.mock.module("ReportIt.constants"));
  
  describe('Integer regex', function() {
    var re;
    
    beforeEach(angular.mock.inject(function(INTEGER_REGEX) {
      re = INTEGER_REGEX;
    }));
             
    it('should match integers', function() {
      expect(re.test('123')).toBe(true);
    });
  
    it('should not match non-integers', function() {
      expect(re.test('abscd')).toBe(false);
    });
  });
  
  describe('Email regex', function() {
    var re;
    beforeEach(angular.mock.inject(function(EMAIL_REGEX) {
      re = EMAIL_REGEX;
    }));
               
    it('should match valid email address', function() {
      expect(re.test('matt@example.com')).toBe(true);
    });
    
    it('should not match invalid email address', function() {
      expect(re.test('abscd')).toBe(false);
    });
  });
});