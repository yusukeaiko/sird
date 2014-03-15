json.array!(@statistics_records) do |statistics_record|
  json.extract! statistics_record, :id, :registry_id, :country_id, :data_type, :start_addr, :end_addr, :value, :prefix, :date, :status, :extensions, :start_addr_dec, :end_addr_dec
  json.url statistics_record_url(statistics_record, format: :json)
end
