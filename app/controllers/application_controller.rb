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
  
  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
    
    def month(num)
      case num
      when 1
        num = "January"
      when 2
        num = "February"
      when 3
        num = "March"
      when 4
        num = "April"
      when 5
        num = "May"
      when 6
        num = "June"
      when 7
        num = "July"
      when 8
        num = "August"
      when 9
        num = "September"
      when 10
        num = "October"
      when 11
        num = "November"
      else
        num = "December"
      end
    end
  end
end