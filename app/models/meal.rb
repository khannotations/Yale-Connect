class Meal
  include Mongoid::Document

  field :date, :type => Date
  field :image, :default => "/assets/no_image.jpg"
  field :feedback
  field :done, :type => Boolean, :default => false
  field :id, :type => String

  belongs_to :user_1, class_name: "User", foreign_key: "user_1_id"
  belongs_to :user_2, class_name: "User", foreign_key: "user_2_id"

  attr_accessible :image, :user_1, :user_2, :done, :date

  validates_presence_of :user_1, :user_2

  # mount_uploader :image, MealTagUploader

  # attr_accessible :done, :date, :feedback

  def get_other(user)
    
    return self.user_2 if user == self.user_1
    return self.user_1 if user == self.user_2
    
    return nil
  end

  def pretty_date
    self.date.strftime("%A, %B %d")
  end


end
