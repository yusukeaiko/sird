# -*- coding: utf-8 -*-
# IANAから最新のIPアドレスリストを取得し、データベースを更新するバッチ処理プログラム
require 'open-uri'
require 'csv'
require 'ipaddr'

module Iana
  TMP_DIR = Rails.root.join('tmp/').to_s

  # American Registry for Internet Numbers :: FTPサイトURL & CSVファイル名
  ARIN_URL = 'ftp://ftp.arin.net/pub/stats/arin/'
  ARIN_FILE = 'delegated-arin-latest'

  # RIPE Network Coordination Centre :: FTPサイトURL & CSVファイル名
  RIPENCC_FILE = 'delegated-ripencc-extended-latest'
  RIPENCC_URL = 'ftp://ftp.ripe.net/pub/stats/ripencc/'

  # Asia-Pacific Network Information Centre :: FTPサイトURL & CSVファイル名
  APNIC_URL = 'ftp://ftp.apnic.net/apnic/stats/apnic/'
  APNIC_FILE = 'delegated-apnic-extended-latest'

  # Latin American and Caribbean Internet Address Registry :: FTPサイトURL & CSVファイル名
  LACNIC_FILE = 'delegated-lacnic-extended-latest'
  LACNIC_URL = 'ftp://ftp.lacnic.net/pub/stats/lacnic/'

  # African Network Information Centre :: FTPサイトURL & CSVファイル名
  AFRINIC_FILE = 'delegated-afrinic-extended-latest'
  AFRINIC_URL = 'ftp://ftp.afrinic.net/pub/stats/afrinic/'

  def self.execute()
    clear()
    self::Arin.exec()
    self::Ripencc.exec()
    self::Apnic.exec()
    self::Lacnic.exec()
    self::Afrinic.exec()
  end

  def self.clear()
    StatisticsRecord.delete_all
    StatisticsVersion.delete_all
    StatisticsSummary.delete_all
    return true
  end

  # APNICからファイルをダウンロードし、一時ディレクトリに格納
  def self.download(csvfile, url)
    ret = false

    open(TMP_DIR + csvfile, 'w') {|file|
      OpenURI.open_uri(url + csvfile) {|data|
        file.write(data.read)
        ret = true
      }
    }

    return ret
  end

  def self.update(tmpfile)
    registry = ''

    CSV.foreach(tmpfile, {:col_sep => '|', :skip_blanks => true}) {|row|
      if  8 >= row.length && row.length >= 5 then
        row.each_with_index {|elem, i| row[i] = elem.to_s.strip}

        case row.length
        when 6
          set_summary(row)
        when 7
          if row[0] =~ /^[0-9].*$/ then
            registry = row[1]
            set_version(row)
          elsif row[0] == registry
            set_record(row)
          end
        when 8
          set_record(row)
        end
      end
    }

    return check_update()
  end

  def self.check_update()
    ret = true
    return ret
  end

  def self.check_date(date)
    begin
      ret = (date.length == 8) ? Date.strptime(date, "%Y%m%d").to_s : nil
    rescue
      ret = nil
    end
    return ret
  end

  def self.set_version(data = {})
    row = {
      :version   => data[0],
      :registry  => data[1],
      :serial    => data[2],
      :records   => data[3].to_i,
      :startdate => check_date(data[4]),
      :enddate => check_date(data[5]),
      :UTCoffset => data[6].to_s.strip
    }

    version = StatisticsVersion.new(row)

    if version.save then
    end
  end

  def self.set_summary(data = {})
    row = {
      :registry  => data[0],
      :data_type => data[2],
      :count     => data[4].to_i,
      :summary   => data[5]
    }
    summary = StatisticsSummary.new(row)

    if summary.save then
    end
  end

  def self.set_record(data = {})
    row = {
      :registry   => data[0],
      :cc         => data[1],
      :data_type  => data[2],
      :start      => data[3],
      :value      => data[4].to_i,
      :date       => check_date(data[5]),
      :status     => data[6],
      :extensions => data[7],
      :start_addr_dec => nil,
      :end_addr_dec => nil
    }

    if row[:start].length > 0 then
      case row[:data_type]
      when 'ipv4'
        row[:start_addr_dec] = IPAddr.new(row[:start]).to_i
        row[:end_addr_dec] = IPAddr.new(row[:start]).to_i + row[:value] - 1
      when 'ipv6'
        row[:start_addr_dec] = IPAddr.new(row[:start]).to_i
      when 'asn'
        row[:start_addr_dec] = row[:start].to_i
        row[:end_addr_dec] = row[:start].to_i + row[:value] - 1
      end
    end

    record = StatisticsRecord.new(row)
    if record.save then
    end
  end
end
