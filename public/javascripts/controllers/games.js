$(document).ready(function() {
  var why_overlay_shown = false;
  $('.card.clickable .box').live("mouseover",function(e){
    $(this).addClass('highlight')
  }).live("mouseout",function(e){
    $(this).removeClass('highlight')
  }).live("click",function(){
    url = $('#show').attr('rel');
    card = $(this).closest('.card');
    data = {'uid':card.attr('givey:uid'), 'duel':card.attr('givey:duel')}
    
    if(finals == true) {
      postWinner(card, url, data)
    } else {
      // card.addClass('selected')
      // $('.card:not(.selected)').fadeOut('fast');
      options = { to: ".winner:first", className: "ui-effects-transfer"};
      $('.round:first').prepend("<div class='trans winner' style='background: #ffffff;width:50px;'>&nbsp;</div>")
      card.effect('transfer', options, 300, postDuel(url, data))
    }
    
    return false;
  })
  
  $('#replace_cards').click(function() {
    if(confirm('We give you ONE skip just in case you find yourself staring at three people and truly have no idea who any of them are.  Are you SURE you want to use it now?')) {
    url = $('#show').attr('rel');
    card = $('.card:first');
    data = {'sub':'true', 'duel':card.attr('givey:duel')}
    postDuel(url, data); }
    return false;
  });
  
  $('#why_continue_btn').click(function() {
    $('#why_overlay').fadeOut()
  });
  
  function postDuel(url, data) {
    $('.card').css('visibility', 'hidden')
    $.post(url, data, function(r) {handleDuelResponse(r)})
  }
  
  function handleDuelResponse(resp) {
      switch(resp.status) {
      case 'duel':
        showDuel(resp);
        if(resp.round == '2' && !why_overlay_shown)  {
          activate_overlay('#why_overlay');
          $('.card').show();
          why_overlay_shown = true;
        }
        break;
      case 'winner':
        showWinner(resp);
        break;
      }
   }
    
    function showDuel (r) {
      finals = r.finals
      console.log(finals);
      loadWinners();
      changeStats(r);
      toggleSkip(r)
      $('#playing_field').html(r.html);
      $('.sc_menu_wrapper').jScrollPane();
      $('.card').css('visibility', '')
    }
    
    function postWinner(card, url, data) {
      uid = card.attr('givey:uid');
      $('.card').each(function() { if ($(this).attr('givey:uid')!=uid)  $(this).effect('explode')})
      $.post(url, data, function(resp) {showWinner(resp)})
    }
    
    function showWinner (r) {
      // $('#battle').hide();
      $('#winner').html(r.html)
      window.setTimeout(function(){activate_overlay('#winner_overlay')},1000);
    }
    
    function changeStats(resp) {
      if (!finals) 
        $('.subtitle').text("Round " + resp.duel_count + " of " + resp.total_battles)
      else
        $('.subtitle').text("The Finals!")
    }
    
    function toggleSkip(r) {
      // error checking since #skip might not exist
      try {        
        if (r.allow_skip == true) 
          $('#skip').show() 
        else
          $('#skip').hide() 
        }
      catch(err) {}
    }
    
    function loadWinners() {
      $('#winners').load($('#show').attr('givey:winners'));
    }
    
});

function activate_overlay (div_id) {
  $(div_id).overlay({
  	top: 160,

  	// disable this for modal dialog-type of overlays
  	closeOnClick: false,
  	
  	closeOnEsc: false,
  	
  	// some mask tweaks suitable for facebox-looking dialogs
    	mask: {

    		// you might also consider a "transparent" color for the mask
    		color: '#000',

        zIndex: 50,

    		// load mask a little faster
    		loadSpeed: 200,

    		// very transparent
    		opacity: 0.80
    	},

  	// load it immediately after the construction
  	load: true
  });
}