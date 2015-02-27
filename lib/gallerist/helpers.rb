# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt

module Gallerist::Helpers

  def library
    settings.library
  end

  def link_to(obj)
    if obj.is_a? Gallerist::Album
      link = obj.name
      url = '/albums/%s' % [ obj.id ]
    elsif obj.is_a? Gallerist::Photo
      link = '<img src="/thumbs/%s">' % [ obj.id ]
      url = '/photos/%s' % [ obj.id ]
    end

    '<a href="%s">%s</a>' % [ url, link ]
  end

  def title
    '%s – Gallerist' % [ @title ]
  end

end
