# Load the rails application
require File.expand_path('../application', __FILE__)

ENV["fbsecret"] = "71d91a73b5e2e58dcf17934a6dcf787a"
ENV["fbkey"] = "390508047659869"

ENV['MONGOID_HOST'] = "ds033097.mongolab.com"
ENV['MONGOID_PORT'] = "33097"
ENV['MONGOID_USERNAME'] = "admin"
ENV['MONGOID_PASSWORD'] = "admin"
ENV['MONGOID_DATABASE'] = "campus"


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