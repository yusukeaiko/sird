# -*- coding: utf-8 -*-
=begin
IPアドレスリストファイル内に格納されているバージョンレコードを管理するModelクラスです。
データはianaモジュールによって投入されます。
=end
class Statistics::Version < ActiveRecord::Base
  belongs_to(:registry)
  has_many(:st_records,
           :class_name => 'Statistics::Record')
end
