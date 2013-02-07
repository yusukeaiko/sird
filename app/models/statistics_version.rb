# -*- coding: utf-8 -*-
=begin
IPアドレスリストファイル内に格納されているバージョンレコードを管理するModelクラスです。
データはianaモジュールによって投入されます。
=end
class StatisticsVersion < ActiveRecord::Base
  attr_accessible :UTCoffset, :enddate, :records, :registry_id, :serial, :startdate, :version
  belongs_to :registry
end
