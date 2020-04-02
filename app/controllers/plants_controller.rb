class PlantsController < ApplicationController

  get '/plants/new' do
    erb :'/plants/new' if logged_in?
  end

  get '/plants/:id/edit' do
    @plant = exists? if logged_in? && exists? && permission?
    erb :'/plants/edit' 
  end

  get '/plants/:id/delete' do
    @plant = exists? if logged_in? && exists? && permission?
    erb :'/plants/delete'
  end

  get '/plants/:id' do
    @plant = exists?
    erb :'/plants/plant'
  end

  get '/plants' do
    redirect '/login' if !logged_in?
    @user = current_user
    @plants = @user.plants.sort_by(&:name)
    erb :'/plants/all'
  end

  delete '/plants' do
    @plant = exists? if logged_in? && exists? && permission?

    if params[:delete] == "no"
      redirect "/plants/#{@plant.id}"
    else
      @plant.delete
      flash[:message] = "Plant deleted"
      redirect "/home"
    end
  end

  patch '/plants' do
    @plant = exists? if logged_in? && exists? && permission?
    @plant.update(params[:plant])
    @plant.calc_avg_water_schedule if @plant.water_avg?
    @plant.set_water_due_date
    @plant.save
    flash[:message] = "Plant successfully edited"
    redirect "/plants/#{@plant.id}"
  end

  post '/plants' do
    @user = current_user
    @plant = @user.plants.build(params[:plant])
    @user.save

    @plant.calc_avg_water_schedule if @plant.water_avg?
    @plant.set_water_due_date
    @plant.save

    flash[:message] = "Plant created"
    redirect "/plants/#{@plant.id}"
  end

  helpers do
    
    def logged_in?
      if !session[:uid]
        flash[:message] = "Must be logged in to add plants"
        redirect "/login"
      else
        !!session[:uid]
      end
    end

    def exists?
      if plant = Plant.find_by_id(params[:id]) 
        plant
      else
        flash[:message] = "No plant with that id in the database"
        redirect '/home'
      end
    end

    def permission?
      if user = Plant.find_by_id(params[:id]).users.find_by(id: session[:uid])
        user
      else
        flash[:message] = "You do not have permission to edit this plant"
        redirect '/home'
      end
    end

  end

end
