WebFontConfig = {
  google: {  families: ['Yanone Kaffeesatz', 'Cabin:bold'] }
};
(function() {
  var wf = document.createElement('script');
  wf.src = ('https:' == document.location.protocol ? 'https' : 'http') +
      '://ajax.googleapis.com/ajax/libs/webfont/1.0.17/webfont.js';
  wf.type = 'text/javascript';
  wf.async = 'true';
  var s = document.getElementsByTagName('script')[0];
  s.parentNode.insertBefore(wf, s);
})();

randomSlide = ''
function randomOrder(){
  return (Math.round(Math.random())-0.5);
}

var isIE = (navigator.appName == 'Microsoft Internet Explorer')

$(document).ready(function() {
  $('.qtip').live('mouseover', function() {
     $(this).qtip({
        overwrite: false, // Make sure another tooltip can't overwrite this one without it being explicitly destroyed
        content: $(this).attr('title'),
        style: 'cream',
        show: {
           ready: true // Needed to make it show on first mouseover event
        }
     })
  })
  
  $('#log_out').click(function() {
    FB.logout();
    return true;
  });
  
	if(randomSlide!=''){
    	$.supersized({
    		startwidth: 640,  
    		startheight: 480,
    		vertical_center: 1,
    		slides: randomSlide
			});
  } 
  
  if (!isIE) $('.sc_menu_wrapper').jScrollPane();
  
  $('.fb_share').live('click',function() {
      var givey_link = $(this).attr('rel');
      if (givey_link=='') {givey_link = 'http://www.givey.org';}
      FB.ui(
         {
           method: 'feed',
           name: "How altruistic am I?",
           link: givey_link,
           caption: 'Givey.org',
           description: "I'm playing Givey.org to find my most altruistic friends but I'm also interested in finding out what you think of me. It's a fun social experiment that's looking for the most philanthropic people on Facebook to give them a voice in how they would change the world through Givey.",
           message: "Check out Givey.org.  I think I'm pretty altruistic but what do you think?"
         }
       );

      return false;
  });
  
  $('a[rel=tweetlink]').click(function() {
    url = $(this).attr('href');
    window.open (url,"tweet_window","menubar=0,resizable=0,location=0,toolbar=0,width=550,height=450");
    return false;
  });
  
  positionFooter(); 
	function positionFooter(){
		var padding_top = $("#footer").css("padding-top").replace("px", "");
		var page_height = $(document.body).height() - padding_top;
		var window_height = $(window).height();
		var difference = window_height - page_height;
		if (difference < 0) 
			difference = 0;
 
		$("#footer").css({
			padding: difference + "px 0 0 0"
		})
	}
 
	$(window)
		.resize(positionFooter)
});

function _ajax_request(url, data, callback, type, method) {
    if (jQuery.isFunction(data)) {
        callback = data;
        data = {};
    }
    return jQuery.ajax({
        type: method,
        url: url,
        data: data,
        success: callback,
        dataType: type
        });
}

jQuery.extend({
    put: function(url, data, callback, type) {
        return _ajax_request(url, data, callback, type, 'PUT');
    },
    delete_: function(url, data, callback, type) {
        return _ajax_request(url, data, callback, type, 'DELETE');
    }
});



