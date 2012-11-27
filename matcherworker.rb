require 'mongoid'
require 'koala'
require "/Users/akshaynathan/projects/Yale-Connect/app/models/user.rb"
require "/Users/akshaynathan/projects/Yale-Connect/app/models/meal.rb"

class MatcherWorker


  def run
    init_mongodb
    # Get all unhiatused users
    candidates = User.where({"hiatus" => false}).to_a  # match preferences
    candidates.each do |user|
      next if user.matched?
      candidates.each do |potential|
        break if user.matched?
        next if potential.matched?
        puts "got #{user.netid} #{potential.netid} unmatched!"
        next if !good_pairing? user, potential
        match(user, potential) # match them
        puts "made a meal: #{user.netid} #{potential.netid}"

        # remove them from array
      end
    end
  end

  def good_pairing? a, b
    return false if a == b # can't be with yourself
    # already checking for this above
    # return false if a.matched? or b.matched?
    # matching year preferences

    return false unless !a.prefers_same_year || (a.prefers_same_year && a.year == b.year)
    return false unless !b.prefers_same_year || (b.prefers_same_year && b.year == a.year)

    # already had a meal together (& is the set intersect operator)

    return false if !((a.meals & b.meals).empty?)

    # If they're friends and one of them wants to exclude fb friends...

    return false if (a.exclude_fb_friends or b.exclude_fb_friends) and fb_friends?(a, b)
    return true
  end

  def match user1, user2
    m = Meal.create(
      user_1: user1,
      user_2: user2
      )
    m.save
  end

  # Stub method
  def fb_friends? a, b
    return false if not a.fbid or not b.fbid # one hasn't allowed fb access

    key = a.fboffline_token.nil? ? a.fbtoken : a.fboffline_token
    graph = Koala::Facebook::API.new(key)

    begin
      friends = graph.get_connections("me", "friends")
    rescue
      puts "#{a.netid}: expired key"
      return false
    end
    friends.each do |f|
      return true if f["id"] == b.fbid
    end
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
