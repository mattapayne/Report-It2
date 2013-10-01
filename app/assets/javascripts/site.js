$(function() {
    
    var loginErrorMessage = '';
    
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
        loginErrorMessage = '';
    });
    
    $("#login-form").on('submit', function(e) {
       e.preventDefault();
       var form = $(this);
       $.ajax({
            method: form.attr('method'),
            data : form.serialize(),
            url: form.attr('action'),
            success: function(response) {
                window.location = response.redirect
            },
            error: function(response) {
                var json = response.responseJSON;
                loginErrorMessage = json.messages.join("\n");
                $("#login-button").popover('show');
            }
        });
    });
    
    $('#logout').on('click', (function(e) {
        e.preventDefault();
        $('#logout-form').submit();
    }));
});