class CreateUserPlantsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :user_plants do |t|
      t.integer :user_id
      t.integer :plant_id
    end
  end
end
