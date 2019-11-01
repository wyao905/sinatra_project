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
      flash[:message] = "*Missing required field."
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
      flash[:message] = "*Incorrect Email or Password."
      redirect "/login"
    end
  end
  
  get '/logout' do
    session.clear
    redirect "/"
	end
	
	get '/users/:slug' do
	  if logged_in?
	    if current_user.slug == params[:slug]
  	    @user = current_user
  	    erb :"/users/show"
  	  else
  	    redirect "/users/#{current_user.slug}"
  	  end
    else
      redirect "/"
    end
	end
	
	get '/users/:slug/balance/edit' do
	  if logged_in?
	    if current_user.slug == params[:slug]
	      @user = current_user
	      erb :"/users/edit_balance"
	    else
	      redirect "/users/#{current_user.slug}"
	    end
	  else
	    redirect "/"
	  end
  end
	
	patch '/users/:slug/balance/edit' do
	  user = current_user
	  if (params[:add_balance] == "" && params[:new_balance] == "") || (params[:add_balance] != "" && params[:new_balance] != "")
	    flash[:message] = "*Invalid Input."
	    redirect "/users/#{user.slug}/balance/edit"
	  elsif params[:add_balance] != ""
	    user.update(balance: user.balance += params[:add_balance].to_f)
	  else
	    user.update(balance: user.balance = params[:new_balance].to_f)
	  end
	  flash[:message] = "*Successfully updated balance."
	  redirect "/users/#{user.slug}"
	end
end