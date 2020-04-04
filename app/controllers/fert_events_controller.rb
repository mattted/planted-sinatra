class FertEventsController < ApplicationController

  get '/fertilizer-events' do
    @user = current_user if logged_in?
    @fevents = @user.fert_events.sort_by(&:date).reverse
    
    erb :'/fert_events/user_all'
  end

  post '/fertilizer-events' do
    # TODO: might need to change pid below
    params[:plants][:pid].each do |id|
      params[:id] = id
      @plant = exists? if logged_in? && exists? && permission?
      @plant.fert_events.build(params[:fevent])
      @plant.save
      @plant.calc_avg_fert_schedule if @plant.fert_avg?
      @plant.set_fert_due_date
    end

    redirect '/fertilizer-events'
  end

  get '/fertilizer-events/new' do
    @user = current_user if logged_in?
    @plants = @user.plants.sort_by(&:fert_due)

    erb :'/fert_events/new_many'
  end

  get '/plants/:id/new-fert-event' do
    @plant = exists? if logged_in? && exists? && permission?
    erb :'/fert_events/new'
  end

  get '/plants/:id/delete-fertilizer-event/:fid' do
    @fevent = fexists? if logged_in? && exists? && fexists? && permission?
    erb :'/fert_events/delete'
  end

  delete '/plants/fertilizer-events' do
    @fevent = fexists? if logged_in? && exists? && fexists? && permission?
    if params[:delete] == "no"
      redirect "/plants/#{params[:id]}/fertilizer-events"
    else
      @fevent.delete
      @plant = exists? if logged_in? && exists? && permission?
      @plant.calc_avg_fert_schedule if @plant.fert_avg?
      @plant.set_fert_due_date

      flash[:message] = "Fertilizer event deleted"
      redirect "/plants/#{params[:id]}/fertlizer-events"
    end
  end

  get '/plants/:id/fertilizer-events' do
    @plant = exists? if logged_in? && exists? && permission?
    @fevents = @plant.fert_events.sort_by(&:date).reverse
    
    erb :'/fert_events/plant_all'
  end

  post '/plants/:id/fertilizer-events' do
    @plant = exists? if logged_in? && exists? && permission?
    @plant.fert_events.build(params[:fevent])
    @plant.save
    @plant.calc_avg_fert_schedule if @plant.fert_avg?
    @plant.set_fert_due_date

    flash[:message] = "Fertlizer event created successfully"
    redirect "/plants/#{params[:id]}"
  end

  helpers do
    
    def logged_in?
      if !session[:uid]
        flash[:message] = "Must be logged in to add or view fertilizer events"
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

    def fexists?
      if fert = FertEvent.find_by_id(params[:fid])
        fert
      else
        flash[:message] = "No fertilizer event with that id in the database"
        redirect '/home'
      end
    end
  end

end
