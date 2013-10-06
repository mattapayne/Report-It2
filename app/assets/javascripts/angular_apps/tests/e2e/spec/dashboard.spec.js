describe('Dashboard', function() {
  
  var p;
  
  var login = function() {
    p = protractor.getInstance();
    p.driver.get('http://localhost:3000');
    p.driver.findElement(protractor.By.name('email')).sendKeys('paynmatt@gmail.com');
    p.driver.findElement(protractor.By.name('password')).sendKeys('232423');
    p.driver.findElement(protractor.By.id('login-button')).click();
  };
  
  var logout = function() {
    p = protractor.getInstance();
    p.driver.findElement(protractor.By.id('logout')).click();
  }
  
  beforeEach(function() {
    login();
  });
  
  afterEach(function() {
    logout();  
  });
  
  it("should display the current user's gravatar", function() {
    var dashboardLink = p.driver.findElement(protractor.By.linkText('Dashboard'));
    expect(dashboardLink.getText()).toEqual('Dashboard');
  });
});