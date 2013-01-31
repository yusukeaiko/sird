class CreateStatisticsSummaries < ActiveRecord::Migration
  def change
    create_table :statistics_summaries do |t|
      t.integer :registry_id, :null => false
      t.string :data_type, :null => false
      t.integer :count
      t.string :summary

      t.timestamps
    end

    add_index(:statistics_summaries, :registry_id)
  end
end
