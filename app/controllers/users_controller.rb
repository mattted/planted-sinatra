class UsersController < ApplicationController

  get '/home' do
    redirect '/login' if !logged_in?
    @user = current_user
    @rec_plants = @user.recent_plants
    @overdue_plants = @user.overdue_plants
    erb :'/users/home'
  end

end
