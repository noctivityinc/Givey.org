jQuery(document).ready(function($) {
  $('#user_npo_id').live('change',function() {
    if($(this).val()=='other') {
      $('.other').fadeIn().effect('highlight',{},3000);
    }
  });
  
  $('#other_name').live('keydown.autocomplete', function(){
    $(this).autocomplete({
    source: '/npos',
    minLength: 3,
    select: function( event, ui ) {
      $('#other_npo_id').val(ui.item.id);
    }
  })})
  
  $('#user_story_form').live('submit',function() {
    if (other_not_specified()) {
      alert("Please enter your charity's name and select it from the drop down list.  Your cause MUST BE a registered 501(c)3.  If you are certain it is but still does not appear in that list, please send an email to addmycause@givey.org and select another charity (for now) to proceed.")
      return false;
    } else if (missing('#user_npo_id') || missing('#user_story')) {
      alert('Please select a cause and tell us why it matters to you')
      return false;
    } else if (!enough_words()) {
      alert('Please enter a few more words about why this cause matters to you.  Everyone will read it :)')
      return false;      
    } else {
      return true;
    }
  });
});

function missing (div) {
  return ($(div).val()=='') 
}

function enough_words() {
  return (cnt($('#user_story').val()) > 5) 
}

function cnt(y){
  var r = 0;
  a=y.replace(/\s/g,' ');
  a=a.split(' ');
  for (z=0; z<a.length; z++) {if (a[z].length > 0) r++;}
  return r;
}

function other_not_specified()  {
  if($('#user_npo_id').val()=='other' && $('#other_npo_id').val()=='') {
    return true;
  }
  return false;
}