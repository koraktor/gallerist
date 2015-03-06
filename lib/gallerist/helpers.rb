# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

module Gallerist::Helpers

  def library
    settings.library
  end

  def link_to(obj)
    classes = []

    case obj
    when Gallerist::Album
      link = obj.name
      url = '/albums/%s' % [ obj.id ]
    when Gallerist::Photo
      classes << 'thumbnail'
      link = '<img src="/thumbs/%s" title="%s">' % [ obj.id, obj.tags.join(', ') ]
      url = '/photos/%s' % [ obj.id ]
    when Gallerist::Tag
      link = obj.name
      url = '/tags/%s' % [ URI.encode(obj.simple_name) ]
    end

    classes = classes.empty? ? '' : ' class="%s"' % [ classes.join(' ') ]

    '<a href="%s"%s>%s</a>' % [ url, classes, link ]
  end

  def title
    '%s – Gallerist' % [ @title ]
  end

end
