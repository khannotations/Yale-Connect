class User
  include Mongoid::Document
  require 'net/ldap'
  require 'mechanize'
  require 'koala'
  require 'json'

  field :fname, type: String
  field :lname, type: String
  field :email, type: String
  field :college, type: String
  field :year, type: String
  field :netid, type: String
  field :major, default: "Undecided"

  field :points, type: Integer, default: 0
  field :hiatus, type: Boolean, default: false

  # Preferences for meals
  field :prefers_same_year, default: false
  field :exclude_fb_friends, default: true
  
  # From Facebook
  field :gender
  field :fbid
  field :fbtoken
  field :fboffline_token

  has_many :meals
  # after_create :find_info
  validates_presence_of :netid, :email
  validates_uniqueness_of :netid, :email
  validates_uniqueness_of :fbid, :allow_nil => true
  attr_accessible :netid, :email, :fname, :lname, :year, :college, :prefers_same_year, :fbtoken, :fbid, :major, :points

  scope :leaders, order_by(:points => :desc).limit(5)

  # store the graph as a class variable?
  # @@graph = Koala::Facebook::API.new

  def past_meals
    (Meal.includes(:user_2).where(user_1_id: self.id, done: true).to_a + 
      Meal.includes(:user_1).where(user_2_id: self.id, done: true).to_a)
  end

  def past_matches
    past_matches = []
    meals_one = Meal.includes(:user_2).where(user_1_id: self.id, done: true).to_a
    meals_two = Meal.includes(:user_1).where(user_2_id: self.id, done: true).to_a
    meals_one.each do |m|
      past_matches << m.user_2
    end
    meals_two.each do |m|
      past_matches << m.user_1
    end
    past_matches
  end

  def active_meal
    # Should only be one
    (Meal.includes(:user_2).where(user_1_id: self.id, done: false).limit(1) + 
      Meal.includes(:user_1).where(user_2_id: self.id, done: false).limit(1)).first
  end

  def match
    m = self.active_meal
    return nil if m.nil?
    self == m.user_1 ? m.user_2 : m.user_1
  end

  def matched?
    !self.match.nil?
  end

  def name
    return self.fname.titlecase+" "+self.lname.titlecase if self.fname && self.lname
    "no name"
  end

  def picture
    pic = "/assets/anon.jpg"
    pic = "http://graph.facebook.com/#{self.fbid}/picture?size=square" if self.fbid
  end

  def likes
    graph = Koala::Facebook::API.new(self.fbtoken)
    likes = []
    begin
      likes = graph.get_connections("me", "likes")
    rescue Exception => e
      logger.debug :text => e
      logger.debug :text => "****   Couldn't get likes!!"
    end
    likes
    # Also get interests from database and push it onto the array
    # likes += self.interests
  end

  def get_offline_token
    browser = Mechanize.new
    url = 
"https://graph.facebook.com/oauth/access_token?\
client_id=#{ENV["fbkey"]}&\
client_secret=#{ENV["fbsecret"]}&\
grant_type=fb_exchange_token&\
fb_exchange_token=#{self.fbtoken}"
    browser.get( url )
    # replace other text in the response body
    token = browser.page.body.gsub(/(access_token=|&expires=\d+)/, "")
    self.fboffline_token = token
    self.save
  end

  protected

  def User.get_user netid
    email_regex = /^\s*Email Address:\s*$/i
    known_as_regex = /^\s*Known As:\s*$/i
    year_regex = /^\s*Class Year:\s*$/i
    college_regex = /^\s*Residential College:\s*$/i

    user_hash = {:netid => netid}

    browser = User.make_cas_browser
    browser.get("http://directory.yale.edu/phonebook/index.htm?searchString=uid%3D#{netid}")
    p browser.page
    browser.page.search('tr').each do |tr|
      field = tr.at('th').text
      value = tr.at('td').text.strip
      case field
      when known_as_regex
        user_hash[:fname] = value
      when email_regex
        user_hash[:email] = value
        # names = string before @ sign, split on the period
        names = value[/[^@]+/].split(".")
        user_hash[:fname] = names[0].capitalize if not user_hash[:fname]
        user_hash[:lname] = names[1].capitalize
      when year_regex
        year = value
        user_hash[:year] = year != "" ? year : nil
      when college_regex
        user_hash[:college] = value
      end
    end

    u = User.create(
        netid: user_hash[:netid],
        email: user_hash[:email],
        fname: user_hash[:fname],
        lname: user_hash[:lname],
        year: user_hash[:year],
        college: user_hash[:college]
    )
    if not u.save
      puts "nothing created!" 
      p user_hash
      p u.errors
    end
    u
  end

  def User.make_cas_browser
    browser = Mechanize.new
    browser.get( 'https://secure.its.yale.edu/cas/login' )
    form = browser.page.forms.first
    form.username = ENV['NETID']
    form.password = ENV['CAS_PASS']
    form.submit
    browser
  end
end
