class Registry < ActiveRecord::Base
  attr_accessible :cover_area, :data_file, :data_uri, :regional_internet_registry, :registry, :uri
end
