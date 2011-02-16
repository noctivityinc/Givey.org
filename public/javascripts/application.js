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
  
  $.fn.supersized.options = {  
		startwidth: 640,  
		startheight: 480,
		vertical_center: 1,
		slides: randomSlide
	};
	
	if(randomSlide!=''){
    $('#supersized').supersized();
  } 
  
  $('.sc_menu_wrapper').jScrollPane();
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
