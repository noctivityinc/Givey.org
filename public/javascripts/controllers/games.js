$(document).ready(function() {
  $('.sc_menu_wrapper').jScrollPane();
  
  var finals = false;
  $('.card .box').live("mouseover",function(e){
    $(this).addClass('highlight')
  }).live("mouseout",function(e){
    $(this).removeClass('highlight')
  }).live("click",function(){
    url = $('#show').attr('rel');
    card = $(this).closest('.card');
    duel = card.attr('givey:duel');
    uid = card.attr('givey:uid');
    
    if(finals == true) {
      postWinner(card, url, uid, duel)
    } else {
      options = { to: ".winner:first", className: "ui-effects-transfer"};
      card.effect('transfer', options, 350, loadDuel(url, uid, duel));
    }
    
    return false;
  })
  
  function loadDuel(url, uid, duel) {
    $('.card').css('visibility', 'hidden')
    $.ajax({
      url: url,
      data: {'uid':uid, 'duel':duel},
      type: 'POST',
      success: function(resp) {
      console.log(resp)
          if (resp.status == 'duel') {
            finals = resp.finals
            loadWinners();
            $('#playing_field').html(resp.html)
            $('.sc_menu_wrapper').jScrollPane();
            changeStats(resp);
          } 
       }
      })
    }
    
    function postWinner(card, url, uid, duel) {
      $('.card').each(function() {
          if ($(this).attr('givey:uid')!=uid) 
            $(this).effect('explode')
        })
        $('#winner').load(url, {'uid':uid, 'duel':duel}, function(resp){
          $('#battle').hide();
          window.setTimeout(function(){activate_overlay()},2000);
        })
    }
    
    function changeStats(resp) {
      if ((resp.duel_count) < resp.total_duels) 
        $('.subtitle').text("Round " + resp.duel_count + " of " + resp.total_duels)
      else
        $('.subtitle').text("The Finals!")
    }
    
    function loadWinners() {
      $('#winners').load($('#show').attr('givey:winners'));
    }
});

function activate_overlay () {
  $("#overlay").overlay({

  	top: 160,
  	effect: 'apple',
  	mask: {

  		// you might also consider a "transparent" color for the mask
  		color: '#ccc',

  		// load mask a little faster
  		loadSpeed: 200,

  		// very transparent
  		opacity: .75
  	},

  	// disable this for modal dialog-type of overlays
  	closeOnClick: false,

  	// load it immediately after the construction
  	load: true

  });
}