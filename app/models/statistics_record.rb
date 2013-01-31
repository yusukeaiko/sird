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
      addrs.uniq.each {|addr|
        if check_ip(addr, 'ipv4') then
          row = searchAddr(addr, 'ipv4')
        elsif check_ip(addr, 'ipv6') then
          row = searchAddr(addr, 'ipv6')
        elsif addr =~ /^[0-9]+$/ then
          row = searchAddr(addr, 'asn')
        elsif addr =~ /^[a-zA-Z]{2}$/ then
          row = searchCountryCode2(addr)
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

  def self.searchCountryCode2(cc)
    country_id = Country.find_by_alpha2(cc)
    row = country_id == nil ? [] : self.where('country_id = :cc', {:cc => country_id})
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
