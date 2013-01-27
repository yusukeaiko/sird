class CreateApnicRecords < ActiveRecord::Migration
  def change
    create_table :apnic_records do |t|
      t.string :registry
      t.string :cc
      t.string :data_type
      t.string :start
      t.integer :value
      t.date :date
      t.string :status
      t.string :extensions
      t.integer :start_addr_dec
      t.integer :end_addr_dec

      t.timestamps
    end
  end
end
