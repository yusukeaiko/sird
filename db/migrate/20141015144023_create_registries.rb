class CreateRegistries < ActiveRecord::Migration
  def change
    create_table :registries do |t|
      t.string :registry,                   :null => false
      t.string :regional_internet_registry, :null => false
      t.string :cover_area,                 :null => false
      t.string :uri,                        :null => false
      t.string :data_uri,                   :null => false
      t.string :data_file,                  :null => false

      t.timestamps
    end

    add_index(:registries, :registry, :unique => true)
  end
end
