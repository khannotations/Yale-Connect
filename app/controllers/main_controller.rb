class MainController < ApplicationController
  # before_filter CASClient::Frameworks::Rails::Filter, :only => [:auth]

  def index
    # redirect_to "/welcome" and return if not session[:cas_user]
    begin

      @user = User.find(session[:user_id]) if session[:user_id]
      @user = User.find_by_netid("fak23")
      session[:user_id] = @user.id
    rescue
      flash[:error] = "No user!"
    end

  end

  def welcome
  end

  def auth
    id = session[:cas_user]

    if id # Check that user and session exists
      u = User.find_by_netid(id)
      # If first sign in, create user
      u = User.create(netid: id) if not u 
      
      session[:user_id] = u.id

    else
      flash[:error] = "Login failed!"
    end
    redirect_to :root
  end

  def logout
    session[:cas_user] = nil
    flash[:success] = "Logged out!"
    redirect_to "/welcome"
    # CASClient::Frameworks::Rails::Filter.logout(self)
  end
end