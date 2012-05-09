class User < ActiveRecord::Base

  require 'net/ldap'
  require 'koala'
  require 'json'

  # has_many :interests

  after_create :ldap

  attr_accessible :netid, :fbtoken, :fbid


  # store the graph as a class variable?
  # @@graph = Koala::Facebook::API.new

  def name
    self.fname.capitalize+" "+self.lname.capitalize
  end

  def picture
    pic = "/assets/anon.jpg"
    pic = "http://graph.facebook.com/#{self.fbid}/picture?size=square" if self.fbid
  end

  def likes
    graph = Koala::Facebook::API.new(self.fbtoken)
    likes = graph.get_connections("me", "likes")
    # Also get interests from database and push it onto the array
    # likes += self.interests
  end

  def facebook params
    if params[:fbtoken] && params[:fbid]
      self.update_attributes(fbtoken: params[:fbtoken], fbid: params[:fbid])
    end
  end

  protected

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
      guessFromEmail
    end
  
    self.netid = ( p['uid'] ? p['uid'][0] : '' )
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
