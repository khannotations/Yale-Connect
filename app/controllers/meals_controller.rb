class MealsController < ApplicationController

  def create

    user = User.find(session[:user_id])

    meal = user.active_meal
    raise if meal.nil?
    if meal.update_attributes(
      done: true, 
      date: DateTime.now
      )
      points = 1
      p = "point"
      if params[:image]
        points = 2 
        p = "points"
      end

      # HANDLE IMAGE STORING HERE


      meal.user_1.inc(:points, points)
      meal.user_2.inc(:points, points)
      flash[:success] = "Way to go, you just netted yourself #{points} #{p}! Hang tight, you'll get another meal tag soon!"
    else
      flash[:error] = "There was an error--please try again later"
    end
    redirect_to "/"

  end

end
