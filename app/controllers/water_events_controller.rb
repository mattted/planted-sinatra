class WaterEventsController < ApplicationController

  get '/water-events' do
    @user = current_user if logged_in?
    @wevents = @user.water_events.sort_by(&:date).reverse
    
    erb :'/water_events/user_all'
  end

  post '/water-events' do
    if params[:plants].nil?
      flash[:message] = "Must select plants to add water events"
      redirect '/water-events/new'
    end
    params[:plants][:pid].each do |id|
      params[:id] = id
      @plant = exists? if logged_in? && exists? && permission?
      @plant.water_events.build(params[:wevent])
      @plant.save
      @plant.calc_avg_water_schedule if @plant.water_avg?
      @plant.set_water_due_date
    end

    flash[:message] = "Water events created successfully"
    redirect '/water-events'
  end

  get '/water-events/new' do
    @user = current_user if logged_in?
    @plants = @user.plants.sort_by(&:water_due)

    erb :'/water_events/new_many'
  end

  get '/plants/:id/new-water-event' do
    @plant = exists? if logged_in? && exists? && permission?
    erb :'/water_events/new'
  end

  get '/plants/:id/delete-water-event/:wid' do
    @wevent = wexists? if logged_in? && exists? && wexists? && permission?
    erb :'/water_events/delete'
  end

  delete '/plants/water-events' do
    @wevent = wexists? if logged_in? && exists? && wexists? && permission?
    if params[:delete] == "no"
      redirect "/plants/#{params[:id]}/water-events"
    else
      @wevent.delete
      @plant = exists? if logged_in? && exists? && permission?
      @plant.calc_avg_water_schedule if @plant.water_avg?
      @plant.set_water_due_date

      flash[:message] = "Water event deleted"
      redirect "/plants/#{params[:id]}/water-events"
    end
  end

  get '/plants/:id/water-events' do
    @plant = exists? if logged_in? && exists? && permission?
    @wevents = @plant.water_events.sort_by(&:date).reverse
    
    erb :'/water_events/plant_all'
  end

  post '/plants/:id/water-events' do
    @plant = exists? if logged_in? && exists? && permission?
    @plant.water_events.build(params[:wevent])
    @plant.save
    @plant.calc_avg_water_schedule if @plant.water_avg?
    @plant.set_water_due_date

    flash[:message] = "Water event created successfully"
    redirect "/plants/#{params[:id]}"
  end

  helpers do
    
    def logged_in?
      if !session[:uid]
        flash[:message] = "Must be logged in to add or view water events"
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

    def wexists?
      if water = WaterEvent.find_by_id(params[:wid])
        water
      else
        flash[:message] = "No water event with that id in the database"
        redirect '/home'
      end
    end
  end

end
