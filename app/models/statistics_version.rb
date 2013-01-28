class StatisticsVersion < ActiveRecord::Base
  attr_accessible :UTCoffset, :enddate, :records, :registry, :serial, :startdate, :version
end
