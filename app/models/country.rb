class Country < ActiveRecord::Base
  attr_accessible :administrative_division, :alpha2, :alpha3, :area, :country_name, :country_name_ja, :numeric
end
