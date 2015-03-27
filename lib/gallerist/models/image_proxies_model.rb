# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2015, Sebastian Staudt


class Gallerist::ImageProxiesModel < Gallerist::BaseModel

  self.abstract_class = true
  self.database = :image_proxies_db

end
