class MealsController < ApplicationController

  def create
    user = User.find(session[:user_id])
    meal = user.active_meal
    if meal.nil?
      flash[:error] = "There was an error--please try again later"
    elsif meal.done
      flash[:success] = "Your meal buddy already completed the meal. On to the next one!"
    elsif meal.update_attributes(
        done: true, 
        date: DateTime.now)
      points = 1
      p = "point"
      image = params[:image]
      if image
        points = 2 
        p = "points"
        # what are we doing for image processing, right now we can retrieve images by grid.get(id)
        # HANDLE IMAGE STORING HERE
        db = Mongo::Connection.from_uri("mongodb://admin:admin@ds033097.mongolab.com:33097/campus")["campus"] 
        grid = Mongo::Grid.new db 
        id   = grid.put(image)
        meal.update_attributes(id: id)
      end
      meal.user_1.inc(:points, points)
      meal.user_2.inc(:points, points)
      flash[:success] = "Way to go, you just netted yourself #{points} #{p}! Hang tight, you'll get another meal tag soon!"
    else
      flash[:error] = "There was an error--please try again later"
    end
    redirect_to "/"
  end
end
