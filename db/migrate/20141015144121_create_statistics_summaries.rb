class CreateStatisticsSummaries < ActiveRecord::Migration
  def change
    create_table :statistics_summaries do |t|
      t.references :registry, :null => false
      t.string :data_type,   :null => false
      t.integer :count
      t.string :summary

      t.timestamps
    end
  end
end
