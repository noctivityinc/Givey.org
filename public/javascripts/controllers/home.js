var intId;

function showMe() {
      FB.api('/me', function(r) {
        $(document.createElement("a"))
            .attr({ href: '#', title: r.name })
            .text('Not '+r.name+'? Click here')
            .appendTo('#not_user')
            .click(function(){
              window.clearInterval(intId);
              FB.logout(function(resp){
                $('#not_user').hide();
              });
              return false;
            })
        })
  }

$(document).ready(function() {
  FB.getLoginStatus(function(response) {
    if (response.session) {
      showMe()
    } else {
    }
  });
});