class WaterEventsController < ApplicationController

  get '/plants/:id/new-water-event' do
    @plant = exists? if logged_in? && exists? && permission?
    erb :'/water_events/new' if logged_in?
  end

  get '/plants/:id/water-events' do
    @plant = exists? if logged_in? && exists? && permission?
    @wevents = @plant.water_events
    
    erb :'/water_events/all'
  end

  post '/plants/:id/water-events' do
    @plant = exists? if logged_in? && exists? && permission?
    @plant.water_events.build(params[:wevent])
    @plant.save
    @plant.calc_water_schedule if @plant.water_schedule?

    flash[:message] = "Water event created successfully"
    redirect "/plants/#{params[:id]}"
  end

  helpers do
    
    def logged_in?
      if !session[:uid]
        flash[:message] = "Must be logged in to add water events"
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
