jQuery(document).ready(function($) {
  $('#user_story').live('submit',function() {
    if (missing('#user_candidates_npo_id') || missing('#user_candidates_story')) {
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
  return (cnt($('#user_candidates_story').val()) > 5) 
}

function cnt(y){
  var r = 0;
  a=y.replace(/\s/g,' ');
  a=a.split(' ');
  for (z=0; z<a.length; z++) {if (a[z].length > 0) r++;}
  return r;
}