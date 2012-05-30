class UsersController < ApplicationController

  def facebook
    u = User.find(session[:user_id])
    if u.fbid and u.fbtoken 
      render :json => {:status => "success"}
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
end
