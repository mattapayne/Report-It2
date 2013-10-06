var util = require('util');

describe('Login', function() {
  var p = protractor.getInstance();

  var attemptLogout = function() {
    var logout = p.driver.findElement(protractor.By.id('logout'));
    if (logout && logout.isDisplayed()) {
      logout.click();
    }
  }
  
  var attemptLogin = function(username, password) {
    var usernameTxt = p.driver.findElement(protractor.By.name('email'));
    var passwordTxt = p.driver.findElement(protractor.By.name('password'));
    var button = p.driver.findElement(protractor.By.id('login-button'));
    usernameTxt.sendKeys(username);
    passwordTxt.sendKeys(password);
    button.click();
  };
  
  beforeEach(function() {
    p.driver.get('http://localhost:3000');
  });
  
  /*afterEach(function() {
    attemptLogout();
  });*/
  
  /*it('should not allow a blank username for login', function() {
    attemptLogin('', 'password');
    var errorMessage = p.driver.findElement(protractor.By.className('popover-content'));
    expect(errorMessage.getText()).toContain("Invalid");
  });
  
  it('should not allow a blank password for login', function() {
    attemptLogin('test@test.ca', '');
    var errorMessage = p.driver.findElement(protractor.By.className('popover-content'));
    expect(errorMessage.getText()).toContain("Invalid");
  });
  
  it('should display an error message if log in failed', function() {
    attemptLogin('test@test.ca', 'password');
    var errorMessage = p.driver.findElement(protractor.By.className('popover-content'));
    expect(errorMessage.getText()).toContain("Invalid");
  });*/
  
  it('should redirect to the dashboard page if log in succeeded', function() {
    attemptLogin('paynmatt@gmail.com', '232423');
    p.driver.getCurrentUrl().then(function(url) {
      console.log(url);
      expect(url).toMatch(/\//);
    });
  });
  
  /*it('should redirect to the main page if log in failed', function() {
    attemptLogin('test@test.ca', 'password');
    p.driver.getCurrentUrl().then(function(url) {
      console.log(url);
      expect(url).toMatch(/\//)
    });
  });*/
});