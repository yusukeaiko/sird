class CreateStatisticsSummaries < ActiveRecord::Migration
  def change
    create_table :statistics_summaries do |t|
      t.string :registry
      t.string :data_type
      t.integer :count
      t.string :summary

      t.timestamps
    end
  end
end
