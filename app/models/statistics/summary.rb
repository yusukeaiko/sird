# -*- coding: utf-8 -*-
=begin
IPアドレスリストファイル内に格納されているサマリレコードを管理するModelクラスです。
データはianaモジュールによって投入されます。
=end
class Statistics::Summary < ActiveRecord::Base
  belongs_to :registry
end
