var intId;
var allFriends;
var friendPosition = 1;

function getFriends() {
  var query = FB.Data.query("SELECT name, pic_square FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me()) ORDER BY rand()");
   query.wait(function(rows) {
      allFriends = rows;
      showFriends()
      intId = window.setInterval('showFriends()',3500)
   });
}

function showFriends () {
  $('.friend').hide()
  for(x = friendPosition;x<friendPosition+3;x++) {
    row = allFriends[x];
    $(document.createElement("img"))
        .attr({ src: row.pic_square, title: row.name })
        .addClass("friend")
        .appendTo('#friends')
  }
  friendPosition = friendPosition + 3;
  if(friendPosition>allFriends.length) friendPosition == 1
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
      getFriends();
    } else {
    }
  });
});