class UsersController < ApplicationController

  def major
    m = params[:major]
    u = User.find(session[:user_id])

    if m and m != "" 
      u.update_attributes(major: m)
    else
      render :json => {:status => "fail", :message => "Invalid major"}
      return
    end
    render :json => {:status => "success", :message => "Major updated!"}
  end

  def hiatus
    @user = User.find(session[:user_id])

    if @user.matched?
      @msg = "You can't go on hiatus with an outstanding meal!!"
      render "main/error"
      return
    end
    @user.hiatus = !@user.hiatus # switch hiatus
    @user.save

    respond_to do |format|
      format.html
      format.js
    end
  end

  def pref
    @user = User.find(session[:user_id])
    friends = params[:friends] == "yes"
    year = params[:year] == "yes"
    @user.exclude_fb_friends = friends
    @user.prefers_same_year = year

    @user.save
    respond_to do |format|
      format.js
    end
  end

  def facebook
    u = User.find(session[:user_id])

    if u.fbid
      if params[:fbtoken]
        u.update_attributes(fbtoken: params[:fbtoken])
        render :json => {:status => "success"}
        u.get_offline_token # Refresh offline_token
      else
        render :json => {:status => "fail"}
      end
    else
      if params[:fbtoken] && params[:fbid]
        u.update_attributes(fbtoken: params[:fbtoken], fbid: params[:fbid])
        render :json => {:status => "refresh"}
        u.get_offline_token # Get offline_token
      else
        render :json => {:status => "fail"}
      end
    end
  end

end


