# -*- coding: utf-8 -*-
require 'ipaddr'

class StatisticsRecord < ActiveRecord::Base
  attr_accessible :cc, :data_type, :date, :end_addr_dec, :extensions, :registry, :start, :start_addr_dec, :status, :value

  def self.search(inaddr)
    data = []
    dataType = ''
    if inaddr.length > 0 then
      addrs = inaddr.split(',')
      addrs.each_index {|key| addrs[key].strip!}
      addrs.uniq.each {|addr|
        if check_ipv4(addr) then
          row = searchAddr(addr, 'ipv4')
        elsif check_ipv6(addr) then
          row = searchAddr(addr, 'ipv6')
        elsif addr =~ /^[0-9]+$/ then
          row = searchAddr(addr, 'asn')
        elsif addr =~ /^[a-zA-Z]{2}$/ then
          row = searchCountryCode2(addr)
        else
          row = [searchEmptyData(addr)]
          data += row
          next
        end

        if (row.length > 0) then data += row end
      }
    end

    return data
  end

  def self.searchAddr(addr, dataType)
    ipdec = (addr =~ /^[0-9]+$/) ? addr : IPAddr.new(addr).to_i
    row = self.where('data_type = :dataType and start_addr_dec <= :ipdec and end_addr_dec >= :ipdec',
                     {:dataType => dataType, :ipdec => ipdec})
    if row.length == 0 then
      row[0] = searchEmptyData(addr)
    else
      row.each_index {|key|
        country = CountryCode.where(:code_2 => row[key][:cc])
        row[key][:area] = country[0][:area]
        row[key][:country] = country[0][:country]
        row[key][:country_ja] = country[0][:country_ja]
        row[key][:input_value] = addr
      }
    end
  end

  def self.searchCountryCode2(cc)
    row = self.where('cc = :cc', {:cc => cc})
    if row.length == 0 then
      row[0] = searchEmptyData(addr)
    else
      row.each_index {|key|
        country = CountryCode.where(:code_2 => row[key][:cc])
        row[key][:area] = country[0][:area]
        row[key][:country] = country[0][:country]
        row[key][:country_ja] = country[0][:country_ja]
        row[key][:input_value] = cc
      }
    end
  end

  def self.searchEmptyData(addr)
    return {
      :id => '',
      :cc => '',
      :date => '',
      :extensions => '',
      :registry => '',
      :start => '',
      :status => '',
      :data_type => '',
      :value => '',
      :start_addr_dec => '',
      :end_addr_dec => '',
      :created_at => '',
      :updated_at => '',
      :area => '',
      :country => '',
      :country_ja => '',
      :input_value => addr
    }
  end

  def self.check_ipv4(addr)
    ret = false
    begin
      ret = IPAddr.new(addr).ipv4?
    rescue
      ret = false
    end
    return ret
  end

  def self.check_ipv6(addr)
    ret = false
    begin
      ret = IPAddr.new(addr).ipv6?
    rescue
      ret = false
    end
    return ret
  end
end
