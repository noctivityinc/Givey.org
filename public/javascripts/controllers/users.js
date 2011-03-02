jQuery(document).ready(function($) {
  $('#user_npo_id').live('change',function() {
    if($(this).val()=='other') {
      $('.other').fadeIn().effect('highlight',{},3000);
    }
  });
  
  $('#other_name').live('keydown.autocomplete', function(){
    $(this).autocomplete({
    source: '/causes',
    minLength: 3,
    select: function( event, ui ) {
      $('#other_npo_id').val(ui.item.id);
    }
  })})
  
  $('#user_story_form').live('submit',function() {
    if (other_not_specified()) {
      alert("Please enter your charity's name and select it from the drop down list.  Your cause MUST BE a registered 501(c)3.  If you are certain it is but still does not appear in that list, please send an email to addmycause@givey.org and select another charity (for now) to proceed.")
      return false;
    } else if (missing('#user_npo_id')) {
      alert('Please select a cause and tell us why it matters to you')
      return false;
    } else {
      return true;
    }
  });
});

function missing (div) {
  return ($(div).val()=='') 
}

function other_not_specified()  {
  if($('#user_npo_id').val()=='other' && $('#other_npo_id').val()=='') {
    return true;
  }
  return false;
}