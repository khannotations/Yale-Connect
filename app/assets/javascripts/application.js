//= require jquery
//= require jquery_ujs
//= require chosen.jquery.min
//= require twitter/bootstrap
//= require_tree .

// jQuery function addon for displaying successes and failures
jQuery.fn.notice = function(msg) {
  $(this).html(msg).parents(".alert").slideDown("fast");
};