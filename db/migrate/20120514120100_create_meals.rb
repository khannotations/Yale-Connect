class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.integer :user1_id
      t.integer :user2_id

      t.string :picture

      t.timestamps
    end
  end
end
