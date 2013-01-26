class CreateApnicVersions < ActiveRecord::Migration
  def change
    create_table :apnic_versions do |t|
      t.string :version
      t.string :registry
      t.integer :serial
      t.integer :records
      t.string :startdate
      t.string :enddate
      t.string :UTCoffset

      t.timestamps
    end
  end
end
