jQuery(document).ready(function($) {
  $('#user_story').live("ajax:success", function(evt, data, status, xhr){
    console.log(xhr.responseText);
  }).live("ajax:error", function(evt, xhr, status, error){
    console.log(xhr.responseText)
  }).live('ajax:complete', function(evt, xhr, status){
    console.log(xhr.responseText)
  })
});
