class CreatePlantsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :plants do |t|
      t.string :name
      t.string :sci_name
      t.string :light
      t.string :water
      t.string :fertilizer
      t.string :temperature
      t.string :humidity
      t.integer :user_id
    end
  end
end
