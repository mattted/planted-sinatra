class UsersController < ApplicationController

  get '/home' do
    redirect '/login' if !logged_in?
    @user = current_user
    erb :'/users/home'
  end

end
