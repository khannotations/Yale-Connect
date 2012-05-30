class Interest
  include Mongoid::Document
  
  belongs_to :user
  
  field :name, :type => String
  field :description, :type => String
  
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
end