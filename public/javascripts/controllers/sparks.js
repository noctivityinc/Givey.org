jQuery(document).ready(function($) {
  
  $('.card.clickable .box').live("mouseover",function(e){
    $(this).addClass('highlight')
  }).live("mouseout",function(e){
    $(this).removeClass('highlight')
  }).live("click",function(){
    card = $(this).closest('.card');
    postSelected(card)
    
    return false;
  })
  
  function postSelected(card) {
    $('#question').hide();
    $('#score_board').hide()

    $('.card').each(function() {
      if($(this).attr('givey:uid')!=card.attr('givey:uid')) $(this).hide();
    })
    
    $('.question').text('recording...').css('color','red')
    $('#question').css('top','200px').css('width','600px').addClass('recording').fadeIn()
    
    url = card.attr('givey:spark_url')
    data = {'uid':card.attr('givey:uid')}
    $.put(url, data, function(r) {handleSelectedResponse(r)})
  }
  
  function handleSelectedResponse(resp) {
      switch(resp.status) {
      case 'spark':
        $('.card').fadeOut();
        
        $('.question').text('next question!').css('color','black')
        window.setTimeout(function() {moveQuestion(resp)},1500);
        break;
      }
   }

   function moveQuestion(resp) {
     changeQuestion(resp)
     $("#question").animate({"width": "960px", "top": "10px", "color" : "red"}, "fast", function() {
       $('#question').removeClass('recording');
       showSpark(resp)
     })
   }
   
   function showScoreboard(){
     $('#score_board').fadeIn('slow')
   }
   
   function showSpark (r) {
     changeStats(r);
     reloadSelectedList(r)
     $('#playing_field').html(r.html).show();
     window.setTimeout(function() {showScoreboard()},1500);
     $('.sc_menu_wrapper').jScrollPane();
   }
   
   function changeQuestion(r) {
    $('.question').text(r.question);
   }
   
   function changeStats(r) {
    $('#counts').text(r.counts)
   }
   
   function reloadSelectedList(r) {
     $('#selected').html(r.selected_list)
   }
  
});
