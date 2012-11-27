class MainController < ApplicationController
  before_filter CASClient::Frameworks::Rails::Filter, :only => [:auth]

  def index
    redirect_to "/welcome" and return if !(session[:cas_user] && session[:user_id])
    # fetch_client_and_user

    begin
      @user = User.find(session[:user_id])
    rescue # Should never happen, in theory.
      flash[:error] = "No such user!"
      redirect_to "/welcome"
      return
    end

    if current_facebook_user
      current_facebook_user.fetch
      # If this is the user's first time logging in with facebook...
      @user.fbid = current_facebook_user.id if !@user.fbid
      if current_facebook_user.id != @user.fbid
        puts "fbid: #{@user.fbid}, c_f_u.id: #{current_facebook_user.id}"
        flash[:error] = "Please log yourself into Facebook." 
        redirect_to "/welcome"
      end
      @user.fbtoken = current_facebook_user.client.access_token
      if !@user.save
        flash[:error] = "Please sign into your own Facebook account first!"
        redirect_to "/welcome" 
        return
      end 
      print "Found a fb user: #{current_facebook_user.first_name}: #{current_facebook_user.client.access_token}"

    end
    db = User.mongo_connect
    @grid = Mongo::Grid.new db 
    @match = @user.match 
    @past_meals = @user.past_meals
    @leaders = User.leaders

  end

  def welcome
  end

  def auth
    id = session[:cas_user]

    if id # Check that user and session exists
      u = User.where(netid: id).first
      # If first sign in, create user
      u = User.get_user(id) if not u 
      
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