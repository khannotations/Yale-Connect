class MainController < ApplicationController
  before_filter CASClient::Frameworks::Rails::Filter, :only => [:auth]

  def index
    redirect_to "/welcome" and return if not (session[:cas_user] and session[:user_id])
    begin
      @user = User.find(session[:user_id])
    rescue # Should never happen, in theory.
      flash[:error] = "No such user!"
      redirect_to "/welcome"
    end

  end

  def welcome
  end

  def auth
    id = session[:cas_user]

    if id # Check that user and session exists
      u = User.where(netid: id).first
      # If first sign in, create user
      u = User.create(netid: id) if not u 

      session[:user_id] = u.id
      redirect_to :root

    else
      flash[:error] = "Login failed!"
      redirect_to "/welcome"
    end
  end

  def logout
    session[:cas_user] = nil
    flash[:success] = "Logged out!"
    #redirect_to "/welcome"
    CASClient::Frameworks::Rails::Filter.logout(self)
  end
end