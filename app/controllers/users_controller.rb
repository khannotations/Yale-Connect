class UsersController < ApplicationController

  def facebook
    u = User.find(session[:user_id])
    u.facebook params
    render :json => {:status => "success"}
  end
end
