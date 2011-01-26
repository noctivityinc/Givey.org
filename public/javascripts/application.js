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
});

