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
    $.put(url, data, function(resp) {timedResponse(resp)})
  }
  
  function timedResponse(resp) {
    window.setTimeout(function(){handleSelectedResponse(resp)},1000)
  }
  
  function handleSelectedResponse(resp) {
      handlePostCallback(resp)
      switch(resp.status) {
      case 'spark':
        $('.card').fadeOut();
        $('.question').text('next question!').css('color','black')
        window.setTimeout(function() {moveQuestion(resp)},1000);
        break;
      case 'overlay':
        $('#overlay').html(resp.html)
        activate_overlay('#overlay')
        break;
      default:
        console.log(resp)
        break;
      }
   }

   function handlePostCallback(resp) {
     if(resp.post_url != undefined) {
       $('#processing_spinner').show()
       $.post(resp.post_url,{},function() {
         $('#processing_spinner').hide()
       })
     } 
   }

   function moveQuestion(resp) {
     changeQuestion(resp)
     $("#question").animate({"width": "960px", "top": "10px", "color" : "red"}, "fast", function() {
       $('#question').removeClass('recording');
       showSpark(resp)
     })
   }
   
   function showFieldAndBoard(resp){
     $('#playing_field').html(resp.html).show();
     $('#score_board').fadeIn('slow');
     $('.sc_menu_wrapper').jScrollPane();
   }
   
   function showSpark (resp) {
     changeStats(resp);
     reloadSelectedList(resp)
     loadBackground(resp)
     window.setTimeout(function() {showFieldAndBoard(resp)},2000);
   }
   
   function changeQuestion(resp) {
    $('.question').text(resp.question);
   }
   
   function changeStats(resp) {
    $('#counts').text(resp.counts)
   }
   
   function loadBackground (resp) {
     $("#supersized img").remove();
		 $("<img/>").attr("src", resp.background).appendTo("#supersized");
     $('#supersized').resizenow(); 
   }
   
   function reloadSelectedList(resp) {
     $('#selected').html(resp.selected_list)
   }
  
});

function activate_overlay (div_id) {
  $(div_id).overlay({
  	top: 160,
  	closeOnClick: false,
  	closeOnEsc: false,
    	mask: {
    		color: '#000',
        zIndex: 50,
    		loadSpeed: 200,
    		opacity: 0.80
    	},
  	load: true
  });
}
