class CreateStatisticsVersions < ActiveRecord::Migration
  def change
    create_table :statistics_versions do |t|
      t.string :version,     :null => false
      t.references :registry, :null => false
      t.integer :serial,     :null => false
      t.integer :records,    :null => false
      t.string :startdate
      t.string :enddate
      t.string :UTCoffset

      t.timestamps
    end
  end
end
