// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require_tree .

$(function() {
  // Tooltip
  $(document).tooltip();

  // Top page button
  $('#pagetop').click(function() {
    $('html,body').animate({scrollTop: 0}, 'fast');
    return false;
  });

  // Global Nav :: About
  $('#about-show').click(function() {
    $('#api:visible').removeAttr('style').fadeOut();
    if ($('#about:visible').size() > 0) {
      $('#about:visible').removeAttr('style').fadeOut();
    } else {
      $('#about').show('blind', {percent: 100}, 'fast');
    }
  });
  $('#about-close').click(function() {
    $('#about:visible').removeAttr('style').fadeOut();
  });
  // Global Nav :: API
  $('#api-show').click(function() {
    $('#about:visible').removeAttr('style').fadeOut();
    if ($('#api:visible').size() > 0) {
      $('#api:visible').removeAttr('style').fadeOut();
    } else {
      $('#api').show('blind', {percent: 100}, 'fast');
    }
  });
  $('#api-close').click(function() {
    $('#api:visible').removeAttr('style').fadeOut();
  });
});

