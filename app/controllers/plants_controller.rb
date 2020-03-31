class PlantsController < ApplicationController

  get '/plants/new' do
    if !logged_in?
      flash[:message] = "Must be logged in to add plants"
      redirect "/login"
    else
      erb :'/plants/new'
    end
  end

  get '/plants/:id' do
    @plant = Plant.find_by_id(params[:id])
    redirect '/home' if @plant.nil?

    erb :'/plants/plant'
  end

  post '/plants' do
    @user = current_user
    @plant = @user.plants.build(params[:plant])
    @user.save

    flash[:message] = "Plant created"
    redirect "/plants/#{@plant.id}"
  end

end
