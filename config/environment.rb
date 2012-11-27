# Load the rails application
require File.expand_path('../application', __FILE__)

credentials = YAML.load_file("#{Rails.root}/config/credentials.yml")

ENV['CAS_NETID'] = credentials['netid']
ENV['CAS_PASS'] = credentials['cas_pass']
ENV['MONGOID_HOST'] = credentials['mongo_host']
ENV['MONGOID_PORT'] = credentials['mongo_port']
ENV['MONGOID_USERNAME'] = credentials['mongo_id']
ENV['MONGOID_PASSWORD'] = credentials['mongo_pass']
ENV['MONGOID_DATABASE'] = credentials['mongo_db']
ENV["fbsecret"] = credentials['fb_secret']
ENV["fbkey"] = credentials['fb_key']

# Initialize the rails application
Connect::Application.initialize!

require 'casclient'
require 'casclient/frameworks/rails/filter'
CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url => "https://secure.its.yale.edu/cas/",
  :username_session_key => :cas_user,
  :extra_attributes_session_key => :cas_extra_attributes
)

ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => true,
  :address => "smtp.sendgrid.net",
  :port => 25,
  :domain => "screwmeyale.com",
  :authentication => :plain,
  :user_name => "fizzcan",
  :password => "screwmeyale"
}