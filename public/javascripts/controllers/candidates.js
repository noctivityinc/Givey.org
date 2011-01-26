jQuery(document).ready(function($) {
  var next_active = false;
  $('#accept').change(function() {
    if ($(this).is(':checked')) {
      $('#next_btn').removeClass('gray-button').addClass('button')
      next_active = true;
    } else {
      $('#next_btn').removeClass('button').addClass('gray-button')
      next_active = false;
    }
  });
  
  $('#next_btn').click(function() {
    if(next_active) 
      return true 
    else 
      return false;
  });
  
  $('.candidates_story_form').submit(function() {
    if(cnt($('#user_candidates_story').val()) < 5) {
      alert('Please enter in a few more words about what you would do with the money if selected to change the world.')
    } else {
      if(confirm('Once your story is submitted, it cannot be changed until the finals (if you are selected).  Are you sure you want to submit this story?'))
        return true
    }
    
    return false;
  });
  
  $('.card').click(function() {
    location.href = $(this).attr('givey:url')
  });
  
  
});

var clip = null;
function clipIt() {
  // setup single ZeroClipboard object for all our elements
  clip = new ZeroClipboard.Client();
  clip.setHandCursor( true );

  // assign a common mouseover function for all elements using jQuery
  $('div.clipit').mouseover( function() {
  	// set the clip text to our innerHTML
  	clip.setText($(this).attr('rel'));

  	// reposition the movie over our element
  	// or create it if this is the first time
  	if (clip.div) {
  		clip.receiveEvent('mouseout', null);
  		clip.reposition(this);
  	}
  	else clip.glue(this);

  	// gotta force these events due to the Flash movie
  	// moving all around.  This insures the CSS effects
  	// are properly updated.
  	clip.receiveEvent('mouseover', null);
  	
  	clip.addEventListener( 'onComplete', function(e) {
  	  $('div.clipit > .text').text('Copied!')
  	});
    
  } );
}


function cnt(y){
  var r = 0;
  a=y.replace(/\s/g,' ');
  a=a.split(' ');
  for (z=0; z<a.length; z++) {if (a[z].length > 0) r++;}
  return r;
}