/**
 * This code is free software; you can redistribute it and/or modify it under
 * the terms of the new BSD License.
 *
 * Copyright (c) 2015, Sebastian Staudt
 */

//=require 'layzr'
//=require 'markerclusterer_compiled'

$(function() {
  var layzr = new Layzr({
    threshold: 5
  });
});

// global object
window.GALLERIST = {};

GALLERIST.showOnMap = function(photos) {

  var map = new google.maps.Map(document.getElementById('map'), {
    'mapTypeId': google.maps.MapTypeId.ROADMAP,
  });
  var bounds = new google.maps.LatLngBounds();
  var markers = [];

  photos.forEach(function(photo) {
    var pos = new google.maps.LatLng(photo.lat, photo.lng);
    var marker = new google.maps.Marker({
      position: pos,
    });

    // TODO: how to handle touch devices?
    google.maps.event.addListener(marker, 'mouseover', function() {

      // thumb size: max 180 x 180 px (see also main.scss)
      var width  = 180 / Math.max(photo.ratio, 1);
      var height = 180 * Math.min(photo.ratio, 1);

      // find click position by converting marker's latlng to pixel
      var overlay = new google.maps.OverlayView();
      overlay.draw = function() {};
      overlay.setMap(map);
      var pixel = overlay.getProjection().fromLatLngToContainerPixel(marker.getPosition());

      // some elementary date pretty-printing
      var date = (new Date(1000*photo.date)).toString()
        .replace(/ GMT.*/, "")
        .replace(/(\d\d:\d\d:\d\d)/, function() { return '<br><span>' + RegExp.$1 + '</span>'; })
      ;

      // show thumbnail of the selected image
      $('#map-thumb')
        .css({
          left: pixel.x - width/2 - 5,
          top: pixel.y - height - 85,
          width: 10 + width,
          height: 10 + height,
          paddingBottom: 28 + height, // room for figcaption
          display: 'block',
        })
        .find('img')
          .attr('src', '/thumbs/' + photo.id)
        .end()
        .find('figcaption')
          .html(date)
      ;
    });

    google.maps.event.addListener(marker, 'mouseout', function () {
      $('#map-thumb').css({display: 'none'});
    });

    google.maps.event.addListener(marker, 'click', function () {
      // TODO: open in new tab if ctrl/cmd-click or middle button
      location.href = '/photos/' + photo.id;
    });

    markers.push(marker);
    bounds.extend(pos);
  });

  // initially zoom the map so that all photo markers are visible
  map.fitBounds(bounds);

  // draw all markers
  new MarkerClusterer(map, markers, {gridSize: 30});
};
