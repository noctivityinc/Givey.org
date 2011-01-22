$(document).ready(function() {
  $('.sc_menu_wrapper').jScrollPane();
  
  $('.card .box').live("mouseover",function(e){
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
      options = { to: ".winner:first", className: "ui-effects-transfer"};
      $('.round:first').prepend("<div class='trans winner' style='background: #ffffff;width:50px;'>&nbsp;</div>")
      card.effect('transfer', options, 250, postDuel(url, data));
    }
    
    return false;
  })
  
  $('#replace_cards').click(function() {
    url = $('#show').attr('rel');
    card = $('.card:first');
    data = {'sub':'true', 'duel':card.attr('givey:duel')}
    postDuel(url, data);
    return false;
  });
  
  function postDuel(url, data) {
    $('.card').css('visibility', 'hidden')
    $.post(url, data, function(r) {handleDuelResponse(r)})
  }
  
  function handleDuelResponse(resp) {
      switch(resp.status) {
      case 'duel':
        showDuel(resp);
        break;
      case 'winner':
        showWinner(resp);
        break;
      }
   }
    
    function showDuel (r) {
      finals = r.finals
      loadWinners();
      changeStats(r);
      $('#playing_field').html(r.html);
      $('.sc_menu_wrapper').jScrollPane();
    }
    
    function postWinner(card, url, data) {
      uid = card.attr('givey:uid');
      $('.card').each(function() { if ($(this).attr('givey:uid')!=uid)  $(this).effect('explode')})
      $.post(url, data, function(resp) {showWinner(resp)})
    }
    
    function showWinner (r) {
      $('#battle').hide();
      $('#winner').html(r.html)
      window.setTimeout(function(){activate_overlay()},1000);
    }
    
    function changeStats(resp) {
      if (!finals) 
        $('.subtitle').text("Round " + resp.duel_count + " of " + resp.total_battles)
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

  	// disable this for modal dialog-type of overlays
  	closeOnClick: false,

  	// load it immediately after the construction
  	load: true

  });
}