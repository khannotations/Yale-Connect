require 'mongoid'
require "/Users/akshaynathan/projects/Yale-Connect/app/models/user.rb"
require "/Users/akshaynathan/projects/Yale-Connect/app/models/meal.rb"

class MatcherWorker


  def run
    init_mongodb
    # Get all unmatched, unhiatused users
    candidates = User.where({"matched" => false, "hiatus" => false}).to_a  # match preferences

    candidates.each do |user|
      candidates.each do |potential|
        next if !good_pairing? user, potential

        match(user, potential) # match them
        # remove them from array
      end
    end
  end

  def good_pairing? a, b
    return false if a == b # can't be with yourself
    return false if a.matched or b.matched
    # matching year preferences
    return false unless a.preferred_year == b.year || a.preferred_year.nil?
    return false unless b.preferred_year == a.year || b.preferred_year.nil?

    # already had a meal together (& is the set intersect operator)
    return false if !((a.meals & b.meals).empty?)

    # If they're friends and one of them wants to exclude fb friends...
    #return false if fb_friends?(a, b) and (a.exclude_fb_friends or b.exclude fb_friends)
    return true
  end

  def match user1, user2
    m = Meal.new
    m.user_1 = user1
    m.user_2 = user2
    m.save
  end

  # Stub method
  def fb_friends? a, b
    true
  end

  def init_mongodb
    Mongoid.configure do |config|
      config.database = Mongo::Connection.from_uri("mongodb://admin:admin@ds033097.mongolab.com:33097/campus")["campus"]
      config.persist_in_safe_mode = false
    end
  end
end

if __FILE__ == $0
  x = MatcherWorker.new
  x.run # or go, or whatever
end
