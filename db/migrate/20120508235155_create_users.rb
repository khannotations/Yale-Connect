class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :fname
      t.string :lname
      t.string :email
      t.string :college
      t.string :year
      t.string :netid
      t.string :major, :default => "Undecided"

      # From Facebook
      t.string :gender
      t.string :fbid
      t.string :fbtoken
      
      t.timestamps

      t.timestamps
    end
  end
end
