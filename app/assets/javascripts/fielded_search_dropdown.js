// Retrigger the fielded search dropdown after navigating the site
// through turbolinks
$(document).on('turbolinks:load', function() {
  $(window).trigger('load.bs.select.data-api');
});