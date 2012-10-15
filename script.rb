require 'mongoid'
require "/Users/rafi/Desktop/Programming/rails/connect/app/models/user.rb"
require "/Users/rafi/Desktop/Programming/rails/connect/app/models/meal.rb"

# require "/Users/akshaynathan/projects/Yale-Connect/app/models/user.rb"
# require "/Users/akshaynathan/projects/Yale-Connect/app/models/meal.rb"

Mongoid.configure do |config|
      config.database = Mongo::Connection.from_uri("mongodb://admin:admin@ds033097.mongolab.com:33097/campus")["campus"]
      config.persist_in_safe_mode = false
end

ids = %w[1 2 3 4 5 6 7 8 9 10]
emails = %w[11 12 13 14 15 16 17 18 19 20]
years = []# ["2015", "2014", "2014", "2015", "2015", "2014", "2014", "2014", "2015", "2014"]
p_years = [] #["2015", "2014", "2014", nil, "2015", "2014", "2014", nil, nil, "2014"]

User.delete_all
Meal.delete_all

(0..9).each do |i|
    User.create!(netid: ids[i], email: emails[i], year: years[i], preferred_year: p_years[i]) #, fbtoken: ids[i], fbid: emails[i]) 
end

# array = [1, 8, 9]
array = []
array.each do |i|
    User.all.to_a[i].update_attributes(matched: true)
end



