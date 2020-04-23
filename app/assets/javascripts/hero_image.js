// Retrigger the hero image carousel after navigating the site
// through turbolinks
$(document).on('turbolinks:load', function() {
  $('.carousel').carousel();
});