# -*- coding: utf-8 -*-
=begin
IPアドレスリストファイル内に格納されているレコードを管理するModelクラスです。
データはianaモジュールによって投入されます。
=end
class Statistics::Record < ActiveRecord::Base
  belongs_to :registry
  belongs_to :country

  # 入力値を受け取り、バリデーション及び値の分割、検索を取得
  # _inaddr_ :: 入力された文字列を受け取ります。
  # 戻り値 :: 検索結果を返します。
  def self.search(inaddr)
    data = Array.new()
    dataType = ''
    if inaddr.length > 0 then
      addrs = inaddr.split(',')
      addrs.each_index {|key| addrs[key].strip!}
      addrs.delete_if {|addr| addr.length == 0}
      Rails.logger.debug("!! TEST !! :: #{addrs.to_s}")
      addrs.uniq.each {|addr|
        if check_ip(addr, 'ipv4') then
          row = searchAddr(addr, 'ipv4')
        elsif check_ip(addr, 'ipv6') then
          row = searchAddr(addr, 'ipv6')
        elsif addr =~ /^[0-9]+$/ then
          row = searchAddr(addr, 'asn')
        elsif addr =~ /^[a-z]{2}(:asn|:ipv4|:ipv6)*$/i then
          row = searchCountryAlpha2(addr)
        else
          row = select_column(addr, [])
          data += row
          next
        end

        data += row
      }
    end

    return data
  end

  # 入力値がASN/IPv4/IPv6だと思われる場合の検索結果を取得
  # _addr_ :: 入力されたアドレスを受け取ります。
  # _dataType_ :: (asn|ipv4|ipv6)を受け取ります。
  # 戻り値 :: 検索結果を返します。検索結果がない場合はデータのないハッシュを返します。
  def self.searchAddr(addr, dataType)
    ipdec = (addr =~ /^[0-9]+$/) ? addr : IPAddr.new(addr).to_i
    row = self.where('data_type = :dataType and start_addr_dec <= :ipdec and end_addr_dec >= :ipdec',
                     {:dataType => dataType, :ipdec => StringConvertConcern.zero_fill_number_string(ipdec)})
    row = select_column(addr, row)
  end

  # 入力値がカントリーコードだと思われる場合の検索結果を取得
  # _cc_ :: カントリーコード + データタイプを受け取ります。
  # 戻り値 :: 検索結果を返します。検索結果がない場合はデータのないハッシュを返します。
  def self.searchCountryAlpha2(cc)
    alpha2 = ''
    types = Array.new()
    cc.split(':').each {|code|
      code = code.downcase
      if code =~ /^[a-z]{2}$/ then
        alpha2 = code.upcase
      elsif ['asn','ipv4','ipv6'].include?(code) then
        types.push(code)
      end
    }

    cond = Hash.new()
    country = Country.find_by_alpha2(alpha2)
    if country != nil then
      cond[:country_id] = country.id
      idPhrase = 'country_id = :country_id '
      typePhrase = ''
      if types.length > 0 then
        types.uniq!
        typePhrase = 'and data_type in ('
        types.each_with_index {|type, i|
          typePhrase += (i == 0) ? " :data_type#{i} " : ", :data_type#{i} "
          cond["data_type#{i}"] = type
        }
        typePhrase += ')'
      end
      row = self.where(idPhrase + typePhrase, cond.symbolize_keys)
    else
      row = Array.new()
    end
    row = select_column(cc, row)
  end

  # 検索結果の項目を設定
  # _input_value_ :: 入力された値を受け取ります。
  # _rows_ :: 入力された値を元に抽出した検索結果を受け取ります。
  # 戻り値 :: 入力された値と検索結果をまとめた行を返します。
  def self.select_column(input_value, rows)
    data = Array.new()
    if rows.length > 0 then
      rows.each {|row|
        data.push({ :id => row.id,
                    :cc => row.country.alpha2,
                    :date => row.date,
                    :registry => row.registry.registry,
                    :start_addr => row.start_addr,
                    :end_addr => row.end_addr,
                    :prefix => row.prefix,
                    :value => row.value,
                    :data_type => row.data_type,
                    :status => row.status,
                    :area => row.country.area,
                    :country => row.country.country_name,
                    :country_ja => row.country.country_name_ja,
                    :flag_filename => row.country.flag_filename,
                    :input_value => input_value
                  })
      }
    else
      data.push({ :id => '',
                  :cc => '',
                  :date => '',
                  :registry => '',
                  :start_addr => '',
                  :end_addr => '',
                  :prefix => '',
                  :value => '',
                  :status => '',
                  :data_type => '',
                  :area => '',
                  :country => '',
                  :country_ja => '',
                  :flag_filename => '',
                  :input_value => input_value
                })
    end

    return data
  end

  # IPアドレス形式のバリデーションをおこないます。
  # _addr_ :: IPv4/IPv6とおもわれる入力値を受け取ります。
  # _protcol_ :: 判定したいプロトコル名('ipv4'|'ipv6')を受け取ります。
  # 戻り値 :: _addr_が_protcol_として正しければ *true* を、正しくなければ *false* を返します。
  def self.check_ip(addr, protcol)
    begin
      case protcol
      when 'ipv4'
        ret = IPAddr.new(addr).ipv4?
      when 'ipv6'
        ret = IPAddr.new(addr).ipv6?
      else
        raise
      end
    rescue
      ret = false
    end
    return ret
  end
end
