require 'mongoid'
require "/Users/rafi/Desktop/Programming/rails/connect/app/models/user.rb"
require "/Users/rafi/Desktop/Programming/rails/connect/app/models/meal.rb"

# require "/Users/akshaynathan/projects/Yale-Connect/app/models/user.rb"
# require "/Users/akshaynathan/projects/Yale-Connect/app/models/meal.rb"

Mongoid.configure do |config|
      config.database = Mongo::Connection.from_uri("mongodb://admin:admin@ds033097.mongolab.com:33097/campus")["campus"]
      config.persist_in_safe_mode = false
end

Meal.delete_all
