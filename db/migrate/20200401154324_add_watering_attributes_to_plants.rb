class AddWateringAttributesToPlants < ActiveRecord::Migration[6.0]
  def change
    add_column :plants, :time_until_water, :float
    add_column :plants, :water_due, :boolean
  end
end
