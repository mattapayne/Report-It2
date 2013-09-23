$(function() {
    
    var loginErrorMessage = null;
    
    $("#login-form input[name=email]").focus();
    
    $('html').on('click', function() {
        $("#login-button").popover('hide');
    });
    
    $("#login-button").popover(
    {
        tigger: 'manual',
        placement: 'bottom',
        content: function() { return loginErrorMessage; }
    });
    
    $('#login-button').on('hidden.bs.popover', function () {
        loginErrorMessage = null;
    });
    
    $("#login-form").on('submit', function(e) {
       e.preventDefault();
       var form = $(this);
       $.ajax({
            method: 'POST',
            data : form.serialize(),
            url: $(this).attr('action'),
            success: function(response) {
                window.location = response.redirect
            },
            error: function(response) {
                var json = response.responseJSON;
                loginErrorMessage = json.message;
                $("#login-button").popover('show');
            }
        });
    });
    
    $('#logout').on('click', (function(e) {
        e.preventDefault();
        $('#logout-form').submit();
    }));
});