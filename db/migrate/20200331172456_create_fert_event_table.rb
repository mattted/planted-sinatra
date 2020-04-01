class CreateFertEventTable < ActiveRecord::Migration[6.0]
  def change
    create_table :fert_events do |t|
      t.date :date
      t.string :notes
      t.integer :plant_id

      t.timestamps
    end
  end
end
