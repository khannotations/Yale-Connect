class UsersController < ApplicationController

  def facebook
    u = User.find(session[:user_id])
    u.facebook params
    render :json => {:status => "success"}
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
