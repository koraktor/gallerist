# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

module Gallerist::Helpers

  def library
    settings.library
  end

  def link_to(obj)
    url = url_for obj
    current = (url == request.path)

    classes = []

    case obj
    when Gallerist::Album
      link = obj.name
    when Gallerist::Photo
      classes << 'thumbnail'
      link = '<img src="/thumbs/%s" title="%s">' % [ obj.id, obj.tags.join(', ') ]
    when Gallerist::Tag
      classes << 'label' << 'tag'
      classes << (current ? 'label-info' : 'label-primary')
      link = obj.name
    end

    classes = classes.empty? ? '' : ' class="%s"' % [ classes.join(' ') ]

    if current
      '<span%s>%s</span>' % [ classes, link ]
    else
      '<a href="%s"%s>%s</a>' % [ url_for(obj), classes, link ]
    end
  end

  def title
    '%s – Gallerist' % [ @title ]
  end

  def url_for(obj)
    case obj
    when Gallerist::Album
      '/albums/%s' % [ obj.id ]
    when Gallerist::Photo
      '/photos/%s' % [ obj.id ]
    when Gallerist::Tag
      '/tags/%s' % [ URI.encode(obj.simple_name) ]
    end
  end

end
