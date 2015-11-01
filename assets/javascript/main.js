/**
 * This code is free software; you can redistribute it and/or modify it under
 * the terms of the new BSD License.
 *
 * Copyright (c) 2015, Sebastian Staudt
 */

//=require 'jquery'
//=require 'bootstrap-sprockets'
//=require 'layzr'

function fadeAndHide(elem) {
  var callback = function() { elem.hide() };

  $.support.transition ?
    elem.one('bsTransitionEnd', callback).emulateTransitionEnd(300) :
    callback();

  elem.removeClass('in');
}

function fadeIn(elem) {
  elem.show();
  var _ = elem[0].offsetWidth;
  elem.addClass('in');
}

$(function(){
  var layzr = new Layzr({
    threshold: 5
  });

  var photoModal = $('#photo-modal');

  $(document).keydown(function(e) {
    if (!photoModal.hasClass('in')) {
      return;
    }

    switch (e.which) {
      case 27:
        photoModal.find('.backdrop').click();
        e.preventDefault();
        break;
      case 32:
      case 39:
        photoModal.find('.modal-next').click();
        e.preventDefault();
        break;
      case 37:
        photoModal.find('.modal-prev').click();
        e.preventDefault();
    }
  });

  photoModal.find('.backdrop').click(hideModal);
    var photoModal = $('#photo-modal');
    var video = photoModal.find('video');
    if (video.length > 0) {
      video[0].pause();
    }

    fadeAndHide(photoModal)
  });

  photoModal.find('.modal-next').click(function() {
    var currentUrl = $('#photo-modal').data('current-url');
    $("a[href='" + currentUrl + "']").parent().next().find('a.thumbnail').click();
  });

  photoModal.find('.modal-prev').click(function() {
    var currentUrl = $('#photo-modal').data('current-url');
    $("a[href='" + currentUrl + "']").parent().prev().find('a.thumbnail').click();
  });

  $('a.thumbnail').click(function(e) {
    var link = $(this);
    var url = link.attr('href');

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

    var nextButton = photoModal.find('.modal-next');
    if (link.parent().next().length == 0) {
      fadeAndHide(nextButton)
    } else {
      fadeIn(nextButton)
    }

    var prevButton = photoModal.find('.modal-prev');
    if (link.parent().prev().length == 0) {
      fadeAndHide(prevButton)
    } else {
      fadeIn(prevButton)
    }

    fadeIn(photoModal);

    e.preventDefault();
  });
});
