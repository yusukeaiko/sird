class CreateApnicSummaries < ActiveRecord::Migration
  def change
    create_table :apnic_summaries do |t|
      t.string :registry
      t.string :type
      t.integer :count
      t.string :summary

      t.timestamps
    end
  end
end
