class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :numeric, :null => false
      t.string :alpha3, :null => false
      t.string :alpha2, :null => false
      t.string :country_name, :null => false
      t.string :country_name_ja
      t.string :area
      t.string :administrative_division

      t.timestamps
    end

    add_index(:countries, :numeric, :unique => true)
    add_index(:countries, :alpha3, :unique => true)
    add_index(:countries, :alpha2, :unique => true)
  end
end
