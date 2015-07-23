# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

module Gallerist::App::Helpers

  def library
    settings.library || setup_library
  end

  def link_to(obj, classes = nil)
    url = url_for obj
    current = (url == request.path)

    classes = [ classes ].compact

    case obj
    when Gallerist::Album
      if obj.key_photo
        link = '<div class="key-photo"><img data-layzr="/thumbs/%d"></div> %s' %
                [ obj.key_photo.id, obj.name ]
      else
        link = '<div class="key-photo"></div> %s' % [ obj.name ]
      end
    when Gallerist::Person, Gallerist::Tag
      classes << 'label' << 'tag'
      classes << (current ? 'label-info' : 'label-primary')
      link = obj.name
    when Gallerist::Photo
      classes << 'thumbnail'
      link = '<img data-layzr="/thumbs/%s">' % [ obj.id ]
    end

    classes = classes.empty? ? '' : ' class="%s"' % [ classes.join(' ') ]

    if current
      '<span%s>%s</span>' % [ classes, link ]
    else
      '<a href="%s"%s>%s</a>' % [ url, classes, link ]
    end
  end

  def navbar
    @navbar
  end

  def partial(partial, *options)
    erb :"partials/#{partial}", *options
  end

  def route_exists(url)
    settings.routes['GET'].map(&:first).any? { |route| route =~ url }
  end

  def title
    "#{@title} – Gallerist"
  end

  def url_for(obj)
    case obj
    when Gallerist::Album
      "/albums/#{obj.id}"
    when Gallerist::Person
      "/persons/#{obj.id}"
    when Gallerist::Photo
      "/photos/#{obj.id}"
    when Gallerist::Tag
      "/tags/#{URI.encode obj.simple_name}"
    end
  end

end
