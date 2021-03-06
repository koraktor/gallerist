/**
 * This code is free software; you can redistribute it and/or modify it under
 * the terms of the new BSD License.
 *
 * Copyright (c) 2015-2016, Sebastian Staudt
 */

//=require 'jquery'
//=require 'bootstrap-sprockets'
//=require 'hammer'
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

var slideshowEnabled = false;
function slideshow() {
  slideshowEnabled = true;
  var thumbnails = $('.thumbnail');
  var nextImage = function() {
    thumbnails.eq(Math.floor(Math.random() * thumbnails.length)).click();
    if (slideshowEnabled) {
      setTimeout(nextImage, 5000);
    }
  };
  nextImage()
}

$(function(){
  var layzr = new Layzr({
    threshold: 5
  });

  var showTags = function(joinChar) {
    var tagNames = [];
    $('#selected-tags').find('span').each(function() {
      tagNames.push($(this).data('tag'))
    });

    location.href = $('body').data('base-url') + '/' + tagNames.join(joinChar)
  };

  $('.selected-tags .close').click(function() {
    $('#selected-tags').empty();
    $('.tag-selector').removeClass('hide');
    $('.list-group.tag-selection').removeClass('tag-selection');
    $('.selected-tags').collapse('hide')
  });

  $('#tag-selection-all').click(function() { showTags('+') });
  $('#tag-selection-one').click(function() { showTags(',') });

  $('.tag-selector').click(function(e) {
    e.preventDefault();

    $(this).addClass('hide');

    var tagSimpleName = $(this).data('tag');
    if ($("#selected-tags").find("span[data-tag='" + tagSimpleName + "']").length == 0) {
      var tag = $('<span class="btn btn-success fade" data-tag="' + tagSimpleName + '">' + $(this).data('name') + '</span>');
      tag.click(function() {
        $(this).remove();
        $(".tag-selector[data-tag='" + tagSimpleName + "']").removeClass('hide');

        if ($('#selected-tags').find('span').length == 0) {
          $('.list-group.tag-selection').removeClass('tag-selection');
          $('.selected-tags').collapse('hide');
        }
      });
      tag.hover(function() {
        $(this).toggleClass('btn-success').toggleClass('btn-danger');
      });
      tag.appendTo('#selected-tags');
      tag.addClass('in');
    }

    $('.list-group:not(.tag-selection)').addClass('tag-selection');
    $('.selected-tags:not(.in)').collapse('show');
  });

  var photoModal = $('#photo-modal');
  photoModal.on('show', function() {
    $('body').addClass("no-scroll");
    photoModal.addClass('in')
  });

  $(document).keydown(function(e) {
    if (!photoModal.hasClass('in')) {
      return;
    }

    switch (e.which) {
      case 27: // ESC
        photoModal.find('.backdrop').click();
        e.preventDefault();
        break;
      case 32: // SPACE
      case 39: // ->
        photoModal.find('.modal-next').click();
        e.preventDefault();
        break;
      case 37: // <-
        photoModal.find('.modal-prev').click();
        e.preventDefault();
        break;
      case 70: // F
        photoModal.find('img, video').click();
        e.preventDefault();
        break;
      case 73: // I
        photoModal.find('.metadata-button').click();
        e.preventDefault();
        break;
      case 83: // S
        slideshow();
        e.preventDefault()
    }
  });

  var pauseVideo = function() {
    photoModal.find('video').each(HTMLMediaElement.prototype.pause);
  };

  var hideModal = function() {
    pauseVideo();
    photoModal.removeClass('full');

    var body = $('body');
    body.removeClass("no-scroll");
    history.pushState(null, '', body.data('base-url'));

    photoModal.removeClass('in')
  };
  photoModal.find('.backdrop').click(hideModal);

  photoModal.find('.modal-next').click(function() {
    var currentUrl = $('#photo-modal').data('current-url');
    pauseVideo();
    $("a[href='" + currentUrl + "']").parent().next().find('a.thumbnail').click();
  });

  photoModal.find('.modal-prev').click(function() {
    var currentUrl = $('#photo-modal').data('current-url');
    pauseVideo();
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

    photoModal.find('.modal-next').toggleClass('in', link.parent().next().length == 1);
    photoModal.find('.modal-prev').toggleClass('in', link.parent().prev().length == 1);

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

    var swipe = new Hammer.Manager(photoModal[0], { recognizers: [[ Hammer.Swipe, { direction: Hammer.DIRECTION_HORIZONTAL } ]] });
    swipe.on('swipeleft', function() {
      photoModal.find('.modal-prev').click()
    });
    swipe.on('swiperight', function() {
      photoModal.find('.modal-next').click()
    });
    swipe.set({ enable: true });

    var persons = $('.persons span');
    var tags = $('.tags span');

    persons.empty();
    tags.empty();

    var metadata = link.data('meta');
    $('.metadata-button').toggle(metadata.persons.length > 0 || metadata.tags.length > 0);
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
