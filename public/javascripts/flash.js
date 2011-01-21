$(document).ready(function() {
  $('#flash').slideDown(500,function(){
    window.setTimeout('hide_flash()',4000);
  }).click(function(){
    $('#flash').slideUp('fast');
  })
});

function hide_flash(){
  $('#flash').slideUp();
}
