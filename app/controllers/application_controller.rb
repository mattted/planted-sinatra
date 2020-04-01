require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'

    enable :sessions
    set :session_secret, 'plants'
    register Sinatra::Flash
  end

  get '/' do
    erb :dev
  end

  get '/signup' do
    redirect '/home' if logged_in?
    erb :signup
  end

  post '/signup' do
    user = User.create(params[:user])

    if user.id.nil?
      flash[:message] = user.errors.full_messages.join(", ")
      redirect '/signup'
    else
      session[:uid] = user.id
      flash[:message] = "User #{user.username} created successfully" 
      redirect '/home'
    end
  end

  get '/login' do
    redirect '/home' if logged_in?
    erb :login
  end

  post '/login' do
    if @user = User.find_by(username: params[:username]).try(:authenticate, params[:password])
      session[:uid] = @user.id 
      @user.plants.each do |plant|
        plant.calc_water_schedule if plant.water_schedule?
        plant.save
      end

      redirect '/home'
    else
      flash[:message] = "Invalid login credentials. Please try again."
      redirect '/login'
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  helpers do
    
    def logged_in?
      !!session[:uid]
    end
    
    def current_user
      User.find_by_id(session[:uid])
    end

  end
end
