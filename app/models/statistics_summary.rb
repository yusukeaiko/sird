class StatisticsSummary < ActiveRecord::Base
  attr_accessible :count, :data_type, :registry, :summary
end
