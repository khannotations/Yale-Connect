class UsersController < ApplicationController

  def facebook
    u = User.find(session[:user_id])

    if u.fbid
      if params[:fbtoken]
        u.update_attributes(fbtoken: params[:fbtoken])
        render :json => {:status => "success"}
      else
        render :json => {:status => "fail"}
      end
    else
      if params[:fbtoken] && params[:fbid]
        u.update_attributes(fbtoken: params[:fbtoken], fbid: params[:fbid])
        render :json => {:status => "refresh"}
      else
        render :json => {:status => "fail"}
      end
    end
  end

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
    @u = User.find(session[:user_id])

    if @u.matched
      @msg = "You can't go on hiatus with an outstanding meal!!"
      render "main/error"
      return
    end
    @u.hiatus = !@u.hiatus # switch hiatus
    @u.save

    respond_to do |format|
      format.html
      format.js
    end
  end

  def pref
    @u = User.find(session[:user_id])
    friends = params[:friends] == "yes"
    year = params[:year] == "yes" ? @u.year : false
    @u.exclude_fb_friends = friends
    @u.preferred_year = year

    @u.save
    respond_to do |format|
      format.js
    end
  end
end
