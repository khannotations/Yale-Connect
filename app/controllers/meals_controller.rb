class MealsController < ApplicationController
  def new
    p params

    render :text => "ok"
  end
end
