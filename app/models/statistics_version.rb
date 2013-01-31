class StatisticsVersion < ActiveRecord::Base
  attr_accessible :UTCoffset, :enddate, :records, :registry_id, :serial, :startdate, :version
  belongs_to :registry
end
