# -*- coding: utf-8 -*-
module Iana
  module Update
    def self.execute(registries)
      clear()
      registries.each {|row| update_records(row)}
    end

    def self.clear()
      StatisticsRecord.delete_all
      StatisticsVersion.delete_all
      StatisticsSummary.delete_all
      return true
    end

    def self.update_records(registry)
      tmpfile = TMP_DIR + registry.data_file

      CSV.foreach(tmpfile, {:col_sep => '|', :skip_blanks => true}) {|row|
        if (6..8).include?(row.length) && row[0].strip =~ /^[^#].*$/ then
          row.each_with_index {|elem, i| row[i] = (elem.to_s.strip.length == 0) ? nil : elem.to_s.strip}

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

    def self.check_date(date)
      begin
        ret = (date.length == 8) ? Date.strptime(date, "%Y%m%d").to_s : nil
      rescue
        ret = nil
      end
      return ret
    end

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
        :start       => data[3],
        :value       => data[4].to_i,
        :date        => check_date(data[5]),
        :status      => data[6],
        :extensions  => data[7],
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
end
