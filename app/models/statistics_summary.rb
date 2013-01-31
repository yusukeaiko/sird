class StatisticsSummary < ActiveRecord::Base
  attr_accessible :count, :data_type, :registry_id, :summary
  belongs_to :registry
end
