class PlantsController < ApplicationController

  get '/plants/new' do
    if !logged_in?
      flash[:message] = "Must be logged in to add plants"
      redirect "/login"
    else
      erb :'/plants/new'
    end
  end

  get '/plants/:id/edit' do
    @plant = Plant.find_by_id(params[:id])
    if @plant.nil?
      flash[:message] = "No plant with that id"
      redirect '/home'
    else
      erb :'/plants/edit'
    end
  end

  get '/plants/:id' do
    @plant = Plant.find_by_id(params[:id])
    if @plant.nil?
      flash[:message] = "No plant with that id"
      redirect '/home'
    else
      erb :'/plants/plant'
    end
  end

  patch '/plants' do
    @plant = Plant.find_by_id(params[:plant][:id]) 

    if @plant.nil?
      flash[:message] = "No plant with that id"
      redirect '/home'
    else
      @plant.update(params[:plant])
      flash[:message] = "Plant successfully edited"
      redirect "/plants/#{@plant.id}"
    end

  end

  post '/plants' do
    @user = current_user
    @plant = @user.plants.build(params[:plant])
    @user.save

    flash[:message] = "Plant created"
    redirect "/plants/#{@plant.id}"
  end

end
