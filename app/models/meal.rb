class Meal
  include Mongoid::Document

  has_one :user_1, class_name: "User"
  has_one :user_2, class_name: "User"
  # field :user_2, :type => BSON:ObjectID
  
  field :date, :type => Date
  field :image, :type => String
  field :feedback, :type => String

  attr_accessible :image
  mount_uploader :image, MealTagUploader

end
