class Meal < ActiveRecord::Base
  mount_uploader :image, MealTagUploader
end
