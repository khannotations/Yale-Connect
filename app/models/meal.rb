class Meal
  include Mongoid::Document
  # field :user_2, :type => BSON:ObjectID

  field :date, :type => Date
  field :image
  field :feedback
  field :done, :type => Boolean, :default => false

  belongs_to :user_1, class_name: "User", inverse_of: :meals
  belongs_to :user_2, class_name: "User", inverse_of: :meals

  attr_accessible :image

  validates_presence_of :user_1, :user_2

  before_save :adjust_availability, message: "One of the users is unavailable!"
  # mount_uploader :image, MealTagUploader

  # attr_accessible :done, :date, :feedback

  private

  def adjust_availability
    if not user_1.matched and not user_2.matched
      user_1.matched = true
      user_1.save
      user_2.matched = true
      user_2.save
      true
    else
      false
    end

  end

end
