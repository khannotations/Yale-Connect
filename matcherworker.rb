require 'mongoid'
require 'ironworker'

class MatcherWorker < IronWorker::Base

  merge "app/models/user.rb"
  merge "app/models/meal.rb"

  def run
    # Get all unmatched, unhiatused users
    candidates = User.where({"matched" => false, "hiatus" => false}).to_a  # match preferences

    candidates.each do |user|
      candidates.each do |potential|

        continue if bad_pairing? user, potential

        match(user, potential) # match them
        # remove them from array
        candidates.delete(user) 
        candidates.delete(potential) 
      end
    end
    p candidates # (somehow log all unmatched users)
  end

  def bad_pairing? a, b
    return false if a == b # can't be with yourself
    # matching year preferences
    return false unless a.preferred_year == b.year or a.preferred_year.nil?
    return false unless b.preferred_year == a.year or b.preferred_year.nil?

    # already had a meal together (& is the set intersect operator)
    return false if not(a.meals & b.meals).empty?

    # If they're friends and one of them wants to exclude fb friends...
    # return false if fb_friends?(a, b) and (a.exclude_fb_friends or b.exclude fb_friends)

    return true
  end

  def match user1, user2
    m = Meal.new
    m.user_1 = user1
    m.user_2 = user2
    m.save
    # Sendgrid.send
  end

  # Stub method
  def fb_friends? a, b
    return false if not a.fbid or b.fbid # one hasn't allowed fb access
    # use koala or post to fb to see if they're friends.
    true
  end

  def init_mongodb
    Mongoid.configure do |config|
      config.database = Mongo::Connection.from_uri("mongodb://admin:admin@ds033097.mongolab.com:33097/campus")
      config.persist_in_safe_mode = false
    end
  end
end
