class CreateApnicVersions < ActiveRecord::Migration
  def change
    create_table :apnic_versions do |t|
      t.string :version
      t.string :registry
      t.string :serial
      t.integer :records
      t.date :startdate
      t.date :enddate
      t.string :UTCoffset

      t.timestamps
    end
  end
end
