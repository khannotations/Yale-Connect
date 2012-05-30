class Meal
  include Mongoid::Document
  
  mount_uploader :image, MealTagUploader
end
