# -*- coding: utf-8 -*-
=begin
IANA以下5つのレジストラの名称やURIやIPアドレスファイル名を管理するためのModelクラス。
データはシードデータとして投入します。
=end
class Registry < ActiveRecord::Base
  attr_accessible :cover_area, :data_file, :data_uri, :regional_internet_registry, :registry, :uri
end
