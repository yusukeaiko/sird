# -*- coding: utf-8 -*-
require 'ipaddr'

class ApnicRecord < ActiveRecord::Base
  attr_accessible :cc, :date, :extensions, :registry, :start, :status, :data_type, :value, :start_addr_dec, :end_addr_dec

  def self.search(inaddr)
    data = []
    dataType = ''
    if inaddr.length > 0 then
      inaddr.split(',').each {|addr|
        addr.strip!
        
        if IPAddr.new(addr).ipv4? then
          dataType = 'ipv4'
        elsif IPAddr.new(addr).ipv6? then
          dataType = 'ipv6'
        else
          row[0] = searchEmptyData(addr)
          data += row
          next
        end
        
        ipdec = IPAddr.new(addr).to_i
        row = self.where('data_type = :dataType and start_addr_dec <= :ipdec and end_addr_dec >= :ipdec',
                         {:dataType => dataType, :ipdec => ipdec})
        if row.length == 0 then
          row[0] = searchEmptyData(addr)
        else
          row.each_index {|key|
            country = CountryCode.where(:code_2 => row[key][:cc])
            row[key][:area] = country[0][:area]
            row[key][:country] = "#{country[0][:country]}(#{country[0][:country_ja]})"
            row[key][:input_value] = addr
          }
        end
        
        if (row.length > 0) then data += row end
      }
    end

    return data
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
      :input_value => addr
    }
  end
end
