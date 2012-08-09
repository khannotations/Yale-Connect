class Pair
  include Mongoid::Document

  field :user_1, :type => BSON:ObjectID
  field :user_2, :type => BSON:ObjectID
  
  field :date, :type => Date
  field :picture, :type => String
  field :feedback, :type => String
  
end