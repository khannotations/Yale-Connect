class Pair
  include Mongoid::Document

  field :user_1, :type => Integer
  field :user_2, :type => Integer
  
  field :lunch_date, :type => Date
  field :picture, :type => String
  field :feedback, :type => String
  
end