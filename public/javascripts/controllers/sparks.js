jQuery(document).ready(function($) {

  $('.remove_button').live('click',function() {
    $(this).closest('.box').html("<img src='/images/spinner.gif' class='spinner'>");
    return false;
  }).live('ajax:success', function(event, resp, status, xhr) {
    if(resp.status=='success') {
      $('#playing_field').html(resp.html)
      if(!isIE) $('.sc_menu_wrapper').jScrollPane();
     } else if (resp.status=='not_enough_friends') {
       no_more_friends(resp.url);
     }
  })
  
  $('.card.clickable .box').live("mouseover",function(e){
    $(this).addClass('highlight')
    if(!isIE) $(this).find('.remove_button').show()
  }).live("mouseout",function(e){
    $(this).removeClass('highlight')
    $(this).find('.remove_button').hide()
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
    
    $('.question').text('scoring altruist...').css('color','red')
    $('#question').css('top','200px').css('width','600px').addClass('recording').fadeIn()
    
    url = card.attr('givey:spark_url')
    data = {'uid':card.attr('givey:uid')}
    $.put(url, data, function(resp) {timedResponse(resp)})
  }
  
  function timedResponse(resp) {
    if(resp.status == 'success')
      window.setTimeout(function(){handleSelectedResponse(resp)},750)
    else if(resp.status == 'error')
      location.reload(true)
  }
  
  function handleSelectedResponse(resp) {
      handlePostCallback(resp)
      switch(resp.type) {
      case 'spark':
        $('.card').fadeOut();
        $('.question').text('next question!').css('color','black')
        window.setTimeout(function() {moveQuestion(resp)},750);
        break;
      case 'modal':
        $('#modal').html(resp.html)
        activate_modal()
        break;
      case 'overlay':
        $('#overlay').html(resp.html)
        activate_overlay()
        moveQuestion(resp.spark_resp)
        break;
      case 'end_round':
        document.location.href = resp.url
      default:
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
       $('.question').css('color','black')
       showSpark(resp)
     })
   }
   
   function showFieldAndBoard(resp){
     $('#playing_field').html(resp.html).show();
     $('#score_board').fadeIn('slow');
     $('#candidate_supporter_msg').html(resp.candidate_supporter_msg)
     if(!isIE) $('.sc_menu_wrapper').jScrollPane();
   }
   
   function showSpark (resp) {
     changeStats(resp);
     reloadSparkHistory(resp)
     loadBackground(resp)
     window.setTimeout(function() {showFieldAndBoard(resp)},2000);
   }
   
   function changeQuestion(resp) {
    $('.question').text(resp.question);
   }
   
   function changeStats(resp) {
    $('#counts').html(resp.counts)
   }
   
   function loadBackground (resp) {
     $("#supersized img").remove();
		 $("<img/>").attr("src", resp.background).appendTo("#supersized");
     $('#supersized').resizenow(); 
   }
   
   function reloadSparkHistory(resp) {
     $('.spark_history').html(resp.spark_history)
   }
   
   function no_more_friends(url) {
     location.href = url
   }

   var overlayDiv = $('#trigger_overlay').overlay({
    top: 160,
    mask: '#000',
    api: true
   })
   
   $('#trigger_overlay').live('click',function(){overlayDiv.load();})
   $('#close_overlay').live('click',function(){overlayDiv.close();})
   
   var modalDiv = $('#trigger_modal').overlay({
   	top: 160,
   	closeOnClick: false,
   	closeOnEsc: false,
     	mask: {
     		color: '#000',
         zIndex: 50,
     		loadSpeed: 200,
     		opacity: 0.80
     	}
   })
   
   $('#trigger_modal').live('click',function(){modalDiv .load();})
   $('#close_modal').live('click',function(){modalDiv .close();})
   
   
});

function activate_overlay () {
  $('#trigger_overlay').click();
}

function activate_modal () {
  $('#trigger_modal').click();
}

function exec_new() {
  var ready = false
  var p = 1;
  var data_url;
  url = $('#new').attr('givey:url');
  $.post(url, function(data) {
     if (data.status == 'complete') {
      ready = true;
      data_url = data.url;
     };
    })

  $('#wait_btn').click(function() {
    return false;
  });
  
  $('#next_btn').click(function() {
    location.href = $(this).attr('rel')
    return false;
  });
  
  var int = window.setInterval(function(){
    $('.p'+p).fadeIn();
    p++;
    if(p>6 && ready) {
      window.clearInterval(int);
      $('.wait').hide();
      $('#next_btn').attr('rel',data_url).fadeIn();
      $('.title').text("We're Ready For You!").css('color','red')
    }
  },3000)
}