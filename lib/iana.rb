# -*- coding: utf-8 -*-
# IANAから最新のIPアドレスリストを取得し、データベースを更新するバッチ処理プログラム
require 'open-uri'
require 'ipaddr'
require 'csv'

module Iana
  TMP_DIR = Rails.root.join('tmp/').to_s

  def self.execute()
    registry = Registry.all()
    # if self::Download.execute(registry) then
      self::Update.execute(registry)
    # end
  end
end
