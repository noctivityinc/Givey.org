WebFont.load({
 google: {
 families: ['Yanone Kaffeesatz', 'Cabin:bold']
 }
});

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

