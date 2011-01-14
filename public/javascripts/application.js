WebFont.load({
 google: {
 families: ['Yanone Kaffeesatz', 'Cabin:bold']
 }
});

jQuery(document).ready(function($) {
  $('a[title]').qtip({ style: { name: 'dark', tip: true }})
});
