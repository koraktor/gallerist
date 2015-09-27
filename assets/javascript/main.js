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

    photoModal.show();
    photoModal[0].offsetWidth;
    photoModal.addClass('in');

    e.preventDefault();
  });
});
