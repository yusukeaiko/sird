# -*- coding: utf-8 -*-
=begin
Author:: Yusuke AIKO
Copyright:: Copyright 2013 Yusuke AIKO
=end

require 'open-uri'
require 'ipaddr'
require 'csv'

=begin
IANA以下5つのレジストラから最新のIPアドレスリストを取得し、データベースを更新するバッチ処理モジュール
* {American Registry for Internet Numbers (ARIN)}[https://www.arin.net/]
* {RIPE Network Coordination Centre (RIPE NCC)}[http://www.ripe.net/]
* {Asia-Pacific Network Information Centre (APNIC)}[http://www.apnic.net/]
* {Latin American and Caribbean Internet Address Registry (LACNIC)}[http://www.lacnic.net/]
* {African Network Information Centre (AfriNIC)}[http://www.afrinic.net/]
=end
module Iana
  # IPアドレスリストファイルをダウンロードする一時ディレクトリ
  TMP_DIR = Rails.root.join('tmp/').to_s

  ASN = 'asn'
  IPV4 = 'ipv4'
  IPV6 = 'ipv6'

  # CRONからキックする実行用メソッド
  def self.execute()
    registry = Registry.all()
    if self::Download.execute(registry) then
      self::Update.execute(registry)
    end
  end
end
