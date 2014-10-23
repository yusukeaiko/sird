# -*- coding: utf-8 -*-
module Iana
  # IPアドレスリストファイルを解析し、下記テーブルへの格納を担当するモジュール
  # * statistics_versions
  # * statistics_summaries
  # * statistics_records
  module Update
    # すべてのIPアドレスリストを解析して各テーブルへ反映(起点メソッド)
    # _registry_ :: Registry.allの実行結果を受け取ります。
    # 戻り値 :: 必ずtrueを返します。
    def self.execute(registry)
      clear()
      registry.each {|row| update_records(row)}
      return true
    end

    # statistics系テーブルを初期化(all delete)をおこなう
    # 戻り値 :: 必ず *true* を返します。
    def self.clear()
      StatisticsRecord.delete_all
      StatisticsVersion.delete_all
      StatisticsSummary.delete_all
      return true
    end

    # IPアドレスリストを解析して各テーブルへ反映
    # _registry_ :: Registry.allの実行結果の一行を受け取ります。
    def self.update_records(registry)
      tmpfile = TMP_DIR + registry.data_file

      CSV.foreach(tmpfile, {:col_sep => '|', :skip_blanks => true}) {|row|
        if (6..8).include?(row.length) && row[0].strip =~ /^[^#].*$/ then
          row.each_with_index {|elem, i| row[i] = (elem != nil && elem.to_s.strip.length == 0) ? nil : elem.to_s.strip}

          case row.length
          when 6
            set_summary(registry, row) if row[5] == 'summary'
          when 7
            if row[0] =~ /^[0-9].*$/ then
              set_version(registry, row)
            else
              set_record(registry, row)
            end
          when 8
            set_record(registry, row)
          end
        end
      }
    end

    # yyyymmdd形式の日付のバリデーションとDate型への変換をおこないます。
    # _date_ :: yyyymmdd形式の文字列を受け取ります。
    # 戻り値 :: Date型へ変換可能なら *Date型* を、変換不可なら *nil* を返します。
    def self.check_date(date)
      begin
        ret = (date.length == 8) ? Date.strptime(date, "%Y%m%d").to_s : nil
      rescue
        ret = nil
      end
      return ret
    end

    # statistics_versionsテーブルへレコードを追加します。
    # _registry_ :: Registry.allの実行結果の一行を受け取ります。
    # _data_ :: 解析したIPアドレスリストのバージョン行を受け取ります。
    def self.set_version(registry, data = {})
      row = {
        :version     => data[0],
        :registry_id => registry.id,
        :serial      => data[2],
        :records     => data[3].to_i,
        :startdate   => check_date(data[4]),
        :enddate     => check_date(data[5]),
        :UTCoffset   => data[6].to_s.strip
      }

      version = StatisticsVersion.new(row)
      if version.save then
      end
    end

    # statistics_summariesテーブルへレコードを追加します。
    # _registry_ :: Registry.allの実行結果の一行を受け取ります。
    # _data_ :: 解析したIPアドレスリストのサマリ行を受け取ります。
    def self.set_summary(registry, data = {})
      row = {
        :registry_id => registry.id,
        :data_type   => data[2],
        :count       => data[4].to_i,
        :summary     => data[5]
      }

      summary = StatisticsSummary.new(row)
      if summary.save then
      end
    end

    # statistics_recordsテーブルへレコードを追加します。
    # _registry_ :: Registry.allの実行結果の一行を受け取ります。
    # _data_ :: 解析したIPアドレスリストのレコード行を受け取ります。
    def self.set_record(registry, data = {})
      country_id = nil
      if data[1].length == 2 then
        country = Country.find_by_alpha2(data[1])
        country_id = country.id if country != nil
      end

      row = {
        :registry_id => registry.id,
        :country_id  => country_id,
        :data_type   => data[2],
        :start_addr  => data[3],
        :date        => check_date(data[5]),
        :status      => data[6],
        :extensions  => data[7]
      }
      row.merge!(conv_addr(row[:data_type], row[:start_addr], data[4].to_i))

      record = StatisticsRecord.new(row)
      if record.save then
      end
    end

    def self.conv_addr(type, addr, value)
      row = {
        :end_addr => nil,
        :prefix => nil,
        :value => nil,
        :start_addr_dec => nil,
        :end_addr_dec => nil
      }

      if addr.length > 0 then
        case type
        when IPV4
          row[:prefix] = 32 - Math.log2(value).to_i
          saddr = IPAddr.new(addr).mask(row[:prefix])
          row[:value] = value.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\1,')
          row[:end_addr] = saddr.to_range.last.to_s
          row[:start_addr_dec] = parent.zero_fill_number_string(saddr.to_range.first.to_i)
          row[:end_addr_dec] = parent.zero_fill_number_string(saddr.to_range.last.to_i)
        when IPV6
          saddr = IPAddr.new(addr).mask(value)
          row[:prefix] = value
          row[:value] = (2 ** value).to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\1,')
          row[:end_addr] = saddr.to_range.last.to_s
          row[:start_addr_dec] = parent.zero_fill_number_string(saddr.to_range.first.to_i)
          row[:end_addr_dec] = parent.zero_fill_number_string(saddr.to_range.last.to_i)
        when ASN
          row[:prefix] = Math.log2(value).to_i
          row[:value] = value.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\1,')
          row[:end_addr] = (addr.to_i + value - 1).to_s
          row[:start_addr_dec] = parent.zero_fill_number_string(addr.to_i)
          row[:end_addr_dec] = parent.zero_fill_number_string(row[:end_addr].to_i)
        end
      end
      return row
    end

  end
end
