/**
 * This code is free software; you can redistribute it and/or modify it under
 * the terms of the new BSD License.
 *
 * Copyright (c) 2015-2016, Sebastian Staudt
 */

//=require 'jquery'
//=require 'bootstrap-sprockets'
//=require 'layzr'

HTMLImageElement.prototype.isLoaded = function() {
    if (typeof this.naturalWidth == 'number' && typeof this.naturalHeight == 'number') {
      return !(this.naturalWidth == 0 && this.naturalHeight == 0)
    } else if (typeof this.complete == 'boolean') {
      return this.complete
    } else {
      return true
    }
};

HTMLVideoElement.prototype.isLoaded = function() {
  return this.readyState == 4
};

function fadeAndHide(elem) {
  elem.removeClass('in');
}

function fadeIn(elem) {
  elem.addClass('in');
}

$(function(){
  var layzr = new Layzr({
    threshold: 5
  });

  var photoModal = $('#photo-modal');
  photoModal.on('show', function() {
    $('body').addClass("no-scroll");
    fadeIn(photoModal);
  });

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
        break;
      case 73:
        photoModal.find('.metadata-button').click();
        e.preventDefault()
    }
  });

  var hideModal = function() {
    var video = photoModal.find('video');
    if (video.length > 0) {
      video[0].pause();
    }

    photoModal.removeClass('full');

    var body = $('body');
    body.removeClass("no-scroll");
    history.pushState(null, '', body.data('base-url'));

    fadeAndHide(photoModal)
  };
  photoModal.find('.backdrop').click(hideModal);

  photoModal.find('.modal-next').click(function() {
    var currentUrl = $('#photo-modal').data('current-url');
    $("a[href='" + currentUrl + "']").parent().next().find('a.thumbnail').click();
  });

  photoModal.find('.modal-prev').click(function() {
    var currentUrl = $('#photo-modal').data('current-url');
    $("a[href='" + currentUrl + "']").parent().prev().find('a.thumbnail').click();
  });

  $('a.photo').click(function(e) {
    e.preventDefault();

    var link = $(this);
    var imageUrl = link.attr('href');

    var url = $('body').data('base-url') + '/view/' + link.data('id');
    if (photoModal.hasClass('full')) {
      history.pushState(null, '', url + '/full');
    } else {
      history.pushState(null, '', url);
    }

    if (photoModal.data('current-url') == imageUrl) {
      photoModal.trigger('show');
      return
    }

    var fullView;
    var viewContainer = photoModal.find('.view-container');

    photoModal.data('current-url', imageUrl);
    if (link.data('type') == 'image') {
      fullView = $('<img>');
      fullView.attr('src', imageUrl);
    } else {
      var source = $('<source>');
      source.attr('src', imageUrl);
      fullView = $('<video controls>');
      fullView.attr('poster', imageUrl.replace('photos', 'previews'));
      fullView.append(source);
    }

    var nextButton = photoModal.find('.modal-next');
    if (link.parent().next().length) {
      fadeIn(nextButton)
    } else {
      fadeAndHide(nextButton)
    }

    var prevButton = photoModal.find('.modal-prev');
    if (link.parent().prev().length) {
      fadeIn(prevButton)
    } else {
      fadeAndHide(prevButton)
    }

    var display = function() {
      viewContainer.find('img, video').remove();
      viewContainer.prepend(fullView);
      fullView.click(function() {
        if (photoModal.hasClass('full')) {
          photoModal.removeClass('full');
          history.pushState(null, '', url);
        } else {
          photoModal.addClass('full');
          var fullUrl = url + '/full';
          history.pushState(null, '', fullUrl)
        }
      });

      photoModal.trigger('show');
    };

    var persons = $('.persons span');
    var tags = $('.tags span');

    persons.empty();
    tags.empty();

    var metadata = link.data('meta');
    if (metadata.persons.length) {
      metadata.persons.forEach(function(person, index) {
        if (index) {
          persons.append(', ')
        }
        persons.append('<a href="/persons/' + person.id + '">' + person.name + '</a>');
      });
      persons.parent().show()
    } else {
      persons.parent().hide()
    }

    if (metadata.tags.length) {
      metadata.tags.forEach(function(tag, index) {
        if (index) {
          tags.append(', ')
        }
        tags.append('<a href="/tags/' + tag.searchName + '">' + tag.name + '</a>');
      });
      tags.parent().show()
    } else {
      tags.parent().hide()
    }

    if (fullView[0].isLoaded()) {
      display()
    } else {
      if (link.data('type') == 'image') {
        fullView.load(display)
      } else {
        fullView.bind('loadedmetadata', display)
      }
    }
  });

  $('.metadata-button').click(function(e) {
    e.preventDefault();

    var metadata = $('.metadata');
    var info = $(this).find('.fa-stack-1x');
    var infoBg = $(this).find('.fa-stack-2x');
    if (metadata.css('left') == '0px') {
      metadata.css('left', '100%');
      infoBg.removeClass('fa-circle-o').addClass('fa-circle');
      info.addClass('fa-inverse')
    } else {
      metadata.css('left', '0px');
      infoBg.removeClass('fa-circle').addClass('fa-circle-o');
      info.removeClass('fa-inverse')
    }
  });

  var currentPhoto = $('a.thumbnail.current');
  if (currentPhoto.length == 1) {
    currentPhoto.click();
    currentPhoto[0].scrollIntoView()
  }
});
