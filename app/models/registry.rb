class Registry < ActiveRecord::Base
  has_one(:statistics_version,
          :class_name => 'Statistics::Version')
  has_many(:statistics_summaries,
           :class_name => 'Statistics::Summary')
  has_many(:statistics_records,
           :class_name => 'Statistics::Records')
end
