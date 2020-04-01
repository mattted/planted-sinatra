class CreatePlantsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :plants do |t|
      t.string :name
      t.string :cname
      t.string :sci_name
      t.date :date
      t.boolean :water_track
      t.float :water
      t.boolean :fert_track
      t.float :fert
      t.string :light
      t.string :humidity
      t.float :time_until_water
      t.boolean :water_due

      t.timestamps
    end
  end
end
