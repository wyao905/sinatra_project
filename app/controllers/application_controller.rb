require './config/environment'

class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    erb :index
  end
  
  post "/" do
    if !logged_in?
      if params.keys.include?("login")
        redirect "/login"
      else
        redirect "/signup"
      end
    else
      redirect "/users/#{current_user.slug}"
    end
  end
  
  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end
end