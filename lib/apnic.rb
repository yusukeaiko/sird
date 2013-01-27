# -*- coding: utf-8 -*-
# APNICから最新のIPアドレスリストを取得し、データベースを更新するバッチ処理プログラム
require 'open-uri'
require 'csv'
require 'ipaddr'

class Apnic
  # IPアドレスリストが格納されているAPNICのFTPサイトURL
  URI = 'ftp://ftp.apnic.net/apnic/stats/apnic/'

  # IPアドレスリストが格納されているAPNICのファイル名
  FILE = 'delegated-apnic-extended-latest'
  TMP_DIR = Rails.root.join('tmp/').to_s
  APNIC_FILE = Rails.root.join(TMP_DIR + FILE).to_s
  
  def self.execute()
    if download() then
      update()
    end
  end

  # APNICからファイルをダウンロードし、一時ディレクトリに格納
  def self.download()
    ret = false
    open(APNIC_FILE, 'w') {|file|
      OpenURI.open_uri(URI + FILE) {|data|
        file.write(data.read)
        ret = true
      }
    }
    
    return ret
  end

  def self.update()
    ApnicRecord.delete_all
    ApnicVersion.delete_all
    ApnicSummary.delete_all
    
    CSV.foreach(APNIC_FILE, {:col_sep => '|', :skip_blanks => true}) {|row|
      if  8 >= row.length && row.length >= 5 then
        row.each_with_index {|elem, i| row[i] = elem.to_s.strip}
        
        case row.length
        when 6
          set_summary(row)
        when 7
          set_version(row)
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

  def self.set_version(data = {})
    row = {
      :version   => data[0],
      :registry  => data[1],
      :serial    => data[2],
      :records   => data[3].to_i,
      :startdate => (data[4].length == 8 ? Date.strptime(data[4], "%Y%m%d").to_s : data[4]),
      :enddate   => (data[5].length == 8 ? Date.strptime(data[5], "%Y%m%d").to_s : data[5]),
      :UTCoffset => data[6].to_s.strip
    }
    
    apnic_version = ApnicVersion.new(row)
    
    if apnic_version.save then
    end
  end

  def self.set_summary(data = {})
    row = {
      :registry  => data[0],
      :data_type => data[2],
      :count     => data[4].to_i,
      :summary   => data[5]
    }
    apnic_summary = ApnicSummary.new(row)
    
    if apnic_summary.save then
    end
  end

  def self.set_record(data = {})
    row = {
      :registry   => data[0],
      :cc         => data[1],
      :data_type       => data[2],
      :start      => data[3],
      :value      => data[4].to_i,
      :date       => (data[5].length == 8 ? Date.strptime(data[5], "%Y%m%d").to_s : data[5]),
      :status     => data[6],
      :extensions => data[7],
      :start_addr_dec => nil,
      :end_addr_dec => nil
    }

    if row[:start].length > 0 then
      case row[:data_type]
      when 'ipv4'
        row[:start_addr_dec] = IPAddr.new(row[:start]).to_i
        row[:end_addr_dec] = IPAddr.new(row[:start]).to_i + row[:value]
      when 'ipv6'
        row[:start_addr_dec] = IPAddr.new(row[:start]).to_i
      end
    end
    
    apnic_record = ApnicRecord.new(row)
    if apnic_record.save then
    end
  end
end
