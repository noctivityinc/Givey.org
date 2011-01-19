WebFont.load({
 google: {
 families: ['Yanone Kaffeesatz', 'Cabin:bold']
 }
});

jQuery(document).ready(function($) {
  $(document).ready(function() {
    $('#log_out').click(function() {
      FB.logout();
      return true;
    });
  });
});
