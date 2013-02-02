# -*- coding: undecided -*-
=begin
IPアドレスリストファイル内に格納されているサマリレコードを管理するModelクラスです。
データはianaモジュールによって投入されます。
=end
class StatisticsSummary < ActiveRecord::Base
  attr_accessible :count, :data_type, :registry_id, :summary
  belongs_to :registry
end
