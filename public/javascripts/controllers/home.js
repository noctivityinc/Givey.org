var intId;
function showFriends() {
  var query = FB.Data.query("SELECT name, pic_square FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me()) ORDER BY rand() LIMIT 3");
   query.wait(function(rows) {
      $('.friend').hide()
     $.each(rows, function(ndx, row){
       $(document.createElement("img"))
           .attr({ src: row.pic_square, title: row.name })
           .addClass("friend")
           .appendTo('#friends')
       })
   });
}

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
                $('.friend').hide();
              });
              return false;
            })
        })
  }

$(document).ready(function() {
  FB.getLoginStatus(function(response) {
    if (response.session) {
      showMe()
      showFriends();
      intId = window.setInterval('showFriends()',3500)
    } else {
      console.log('no fb')
    }
  });
});