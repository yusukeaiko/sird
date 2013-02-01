# -*- coding: utf-8 -*-
require 'ipaddr'

class StatisticsRecord < ActiveRecord::Base
  attr_accessible :country_id, :data_type, :date, :end_addr_dec, :extensions, :registry_id, :start, :start_addr_dec, :status, :value
  belongs_to :registry
  belongs_to :country

  def self.search(inaddr)
    data = Array.new()
    dataType = ''
    if inaddr.length > 0 then
      addrs = inaddr.split(',')
      addrs.each_index {|key| addrs[key].strip!}
      addrs.delete_if {|addr| addr.length == 0}
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

  def self.searchAddr(addr, dataType)
    ipdec = (addr =~ /^[0-9]+$/) ? addr : IPAddr.new(addr).to_i
    row = self.where('data_type = :dataType and start_addr_dec <= :ipdec and end_addr_dec >= :ipdec',
                     {:dataType => dataType, :ipdec => ipdec})
    row = select_column(addr, row)
  end

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

  def self.select_column(input_value, rows)
    data = Array.new()
    if rows.length > 0 then
      rows.each {|row|
        data.push({ :id => row.id,
                    :cc => row.country.alpha2,
                    :date => row.date,
                    :registry => row.registry.registry,
                    :start => row.start,
                    :status => row.status,
                    :data_type => row.data_type,
                    :value => row.value,
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
                  :start => '',
                  :status => '',
                  :data_type => '',
                  :value => '',
                  :area => '',
                  :country => '',
                  :country_ja => '',
                  :flag_filename => '',
                  :input_value => input_value
                })
    end

    return data
  end

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
