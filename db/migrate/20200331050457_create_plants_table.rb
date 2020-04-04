class CreatePlantsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :plants do |t|
      t.string :name
      t.string :cname
      t.string :sci_name
      t.date :date
      t.boolean :water_track
      t.float :water_avg
      t.date :water_due
      t.boolean :fert_track
      t.float :fert_avg
      t.date :fert_due
      t.string :light
      t.string :humidity

      t.timestamps
    end
  end
end
