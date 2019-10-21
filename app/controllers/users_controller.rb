class UsersController < ApplicationController
  get '/signup' do
    if logged_in?
      redirect "/users/#{current_user.slug}"
    else
      erb :"/users/create_user"
    end
  end
  
  post '/signup' do
    if params[:name] == "" || params[:email] == "" || params[:password] == ""
      redirect "/signup"
    else
      user = User.create(params)
      if params[:balance] == ""
        user.balance = 0
        user.save
      end
      session[:user_id] = user.id
      redirect "/users/#{user.slug}"
    end
  end
  
  get '/login' do
    if logged_in?
      redirect "/users/#{current_user.slug}"
    else
      erb :"/users/login"
    end
  end
  
  post '/login' do
    user = User.find_by(:email => params[:email])
    
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/users/#{user.slug}"
    else
      redirect "/login"
    end
  end
  
  get '/logout' do
    session.clear
    redirect "/"
	end
	
	get '/users/:slug' do
	  if current_user.slug == params[:slug]
	    @user = current_user
	    @expenses = @user.expenses
	    erb :"/users/show"
	  else
	    redirect "/"
	  end
	end
end