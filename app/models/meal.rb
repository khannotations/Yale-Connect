class Meal
  include Mongoid::Document

  field :date, :type => Date
  field :image
  field :feedback
  field :done, :type => Boolean, :default => false

  belongs_to :user_1, class_name: "User", foreign_key: "user_1_id"
  belongs_to :user_2, class_name: "User", foreign_key: "user_2_id"

  attr_accessible :image

  validates_presence_of :user_1, :user_2

  before_create :adjust_availability, message: "One of the users is unavailable!"
  # mount_uploader :image, MealTagUploader

  # attr_accessible :done, :date, :feedback

  protected
  
  def adjust_availability
    return false if user_1.matched or user_2.matched
    user_1.matched = true
    user_2.matched = true
    user_1.save and user_2.save
  end

end
