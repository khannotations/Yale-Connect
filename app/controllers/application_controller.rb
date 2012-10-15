class ApplicationController < ActionController::Base
  include Facebooker2::Rails::Controller

  helper :all
  protect_from_forgery

end
