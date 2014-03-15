# -*- coding: utf-8 -*-
=begin
ISO 3166に準拠したCountry Code(国コード)を管理するModelクラス。
データはシードデータとして投入します。
=end
class Country < ActiveRecord::Base
  #attr_accessible :administrative_division, :alpha2, :alpha3, :area, :country_name, :country_name_ja, :numeric, :flag_filename
end
