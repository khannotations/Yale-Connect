class Meal
  include Mongoid::Document

  belongs_to :user, :inverse_of => :meals
  # belongs_to :user_2, class_name: "User"
  # field :user_2, :type => BSON:ObjectID
 
  field :done, :type => Boolean

  field :date, :type => Date
  field :image
  field :feedback
  field :done, :type => Boolean, :default => false

  attr_accessible :image
  # mount_uploader :image, MealTagUploader

  # validates_presence_of :user
end
