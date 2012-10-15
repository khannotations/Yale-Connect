class User
  include Mongoid::Document
  require 'net/ldap'
  require 'mechanize'
  require 'koala'
  require 'json'

  field :fname
  field :lname
  field :email
  field :college
  field :year
  field :netid
  field :major, default: "Undecided"

  field :matched, type: Boolean, default: false
  field :points, type: Integer, default: 0
  field :hiatus, type: Boolean, default: false

  # Preferences for meals
  field :preferred_year
  field :exclude_fb_friends
  
  # From Facebook
  field :gender
  field :fbid
  field :fbtoken

  has_many :meals
  # after_create :find_info
  validates_presence_of :netid, :email
  validates_uniqueness_of :netid, :email, :fbtoken, :fbid 
  attr_accessible :netid, :email, :fname, :lname, :fbtoken, :fbid, :major, :matched, :points

  # store the graph as a class variable?
  # @@graph = Koala::Facebook::API.new
  def name
    self.fname.titlecase+" "+self.lname.titlecase
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

  protected

  # NOT WORKING--
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
        year = value.to_i
        user_hash[:year] = year != 0 ? year : nil
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
    end
    u
  end

  def User.make_cas_browser
    browser = Mechanize.new
    browser.get( 'https://secure.its.yale.edu/cas/login' )
    form = browser.page.forms.first
    # If you're seeing this, please don't hack me...
    form.username = "fak23"
    form.password = ENV['CAS_PASS']
    form.submit
    browser
  end

  def ldap
    return false if not self.netid

    begin
      ldap = Net::LDAP.new( :host =>"directory.yale.edu" , :port =>"389" )

      f = Net::LDAP::Filter.eq('uid', self.netid)
      b = 'ou=People,o=yale.edu'
      p = ldap.search(:base => b, :filter => f, :return_result => true).first

    rescue Exception => e
      logger.debug :text => e
      logger.debug :text => "*** ERROR with LDAP"
      return false
    end
  
    # self.netid = ( p['uid'] ? p['uid'][0] : '' )
    self.fname = ( p['knownAs'] ? p['knownAs'][0] : '' )
    if self.fname.blank?
      self.fname = ( p['givenname'] ? p['givenname'][0] : '' )
    end
    self.lname = ( p['sn'] ? p['sn'][0] : '' )
    self.email = ( p['mail'] ? p['mail'][0] : '' )
    self.year = ( p['class'] ? p['class'][0].to_i : 0 )
    self.college = ( p['college'] ? p['college'][0] : '' )
    self.save!
  end
end
