/**
 * This code is free software; you can redistribute it and/or modify it under
 * the terms of the new BSD License.
 *
 * Copyright (c) 2015, Sebastian Staudt
 */

//=require 'jquery'
//=require 'bootstrap-sprockets'
//=require 'layzr'

$(function(){
  var layzr = new Layzr({
    threshold: 5
  });

  $('#photo-modal .backdrop').click(function() {
    var photoModal = $('#photo-modal');
    var video = photoModal.find('video');
    if (video.length > 0) {
      video[0].pause();
    }
    photoModal.removeClass('in');

    var callbackRemove = function() {
      photoModal.hide();
    }

    $.support.transition ?
      photoModal.one('bsTransitionEnd', callbackRemove)
        .emulateTransitionEnd(300) :
      callbackRemove()
  });

  $('#photo-modal .modal-next').click(function() {
    var currentUrl = $('#photo-modal').data('current-url');
    $("a[href='" + currentUrl + "']").parents('.col-md-3').next().find('.thumbnail div:first-child a').click();
  });

  $('#photo-modal .modal-prev').click(function() {
    var currentUrl = $('#photo-modal').data('current-url');
    $("a[href='" + currentUrl + "']").parents('.col-md-3').prev().find('.thumbnail div:first-child a').click();
  });

  $('.thumbnail div:first-child a').click(function(e) {
    var link = $(this);
    var url = link.attr('href');
    var photoModal = $('#photo-modal');

    if (photoModal.data('current-url') != url) {
      photoModal.data('current-url', url);
      var fullView;
      if (link.data('type') == 'image') {
        fullView = $('<img>');
        fullView.attr('src', url);
      } else {
        var source = $('<source>');
        source.attr('src', url);
        fullView = $('<video controls>');
        fullView.append(source);
      }
      photoModal.find('img, video').remove();
      photoModal.append(fullView);
    }

    var nextButton = $('#photo-modal .modal-next');
    if (link.parents('.col-md-3').next().length == 0) {
      nextButton.removeClass('in')
    } else {
      nextButton.addClass('in')
    }

    var prevButton = $('#photo-modal .modal-prev');
    if (link.parents('.col-md-3').prev().length == 0) {
      prevButton.removeClass('in')
    } else {
      prevButton.addClass('in')
    }

    photoModal.show();
    photoModal[0].offsetWidth;
    photoModal.addClass('in');

    e.preventDefault();
  });
});
