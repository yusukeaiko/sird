class CreateCountryCodes < ActiveRecord::Migration
  def change
    create_table :country_codes do |t|
      t.string :country
      t.string :code_2
      t.string :code_3
      t.string :country_ja
      t.string :area
      t.string :code_type

      t.timestamps
    end
  end
end
