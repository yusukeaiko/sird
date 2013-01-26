class ApnicRecord < ActiveRecord::Base
  attr_accessible :cc, :date, :extensions, :registry, :start, :status, :type, :value
end
