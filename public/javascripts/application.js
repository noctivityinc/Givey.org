WebFont.load({
 google: {
 families: ['Yanone Kaffeesatz', 'Cabin:bold']
 }
});

$(document).ready(function() {
  $('#log_out').click(function() {
    FB.logout();
    return true;
  });
  
  function randomOrder(){
  return (Math.round(Math.random())-0.5);
  }

  slideURLs = [
    {image : '/images/backgrounds/waterfall.jpeg'},
    {image : '/images/backgrounds/output4.jpg'},
    {image : '/images/backgrounds/dunes.jpeg'},
    {image : '/images/backgrounds/gsf.jpg'}
  ];

  randomSlide = slideURLs.sort(randomOrder);
  
  $.fn.supersized.options = {  
		startwidth: 640,  
		startheight: 480,
		vertical_center: 1,
		slides: randomSlide
	};
  $('#supersized').supersized();
});

