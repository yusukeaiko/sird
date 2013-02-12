class CreateStatisticsRecords < ActiveRecord::Migration
  def change
    create_table :statistics_records do |t|
      t.integer :registry_id, :null => false
      t.integer :country_id
      t.string :data_type
      t.string :start_addr
      t.string :end_addr
      t.integer :value
      t.integer :block
      t.string :mask
      t.string :date
      t.string :status, :null => false
      t.string :extensions
      t.integer :start_addr_dec
      t.integer :end_addr_dec

      t.timestamps
    end

    add_index(:statistics_records, :registry_id)
    add_index(:statistics_records, :value)
    add_index(:statistics_records, :country_id)
    add_index(:statistics_records, :start_addr_dec)
    add_index(:statistics_records, :end_addr_dec)
  end
end
