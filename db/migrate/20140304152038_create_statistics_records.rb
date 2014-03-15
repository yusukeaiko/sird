class CreateStatisticsRecords < ActiveRecord::Migration
  def change
    create_table :statistics_records do |t|
      t.integer :registry_id, :null => false
      t.integer :country_id, :index => true
      t.string :data_type
      t.string :start_addr
      t.string :end_addr
      t.string :value, :index => true
      t.integer :prefix
      t.string :date
      t.string :status, :null => false
      t.string :extensions
      t.string :start_addr_dec, :index => true
      t.string :end_addr_dec, :index => true

      t.timestamps
    end
  end
end
