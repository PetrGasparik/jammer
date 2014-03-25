//= require jquery
//= require jquery_ujs
//= require_tree .

$(function() {
    // --- Using the default options:
    $(".expand").toggler();
});
(function ($) {

// Log all jQuery AJAX requests to Google Analytics
    $(document).ajaxSend(function(event, xhr, settings){
        if (typeof _gaq !== "undefined" && _gaq !== null) {
            _gaq.push(['_trackPageview', settings.url]);
        }
    });

})(jQuery);