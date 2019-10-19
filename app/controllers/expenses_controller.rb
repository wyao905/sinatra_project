class ExpensesController < ApplicationController
  get '/balance' do
    if logged_in?
      @user = current_user
      @balance = @user.balance
      erb :"/expenses/show_expense"
    else
      redirect "/"
    end
  end
  
  get '/expense/new' do
    if logged_in?
      erb :"/expenses/new"
    else
      redirect "/"
    end
  end
  
  post '/expense/new' do
    if params[:content] != ""
      new_expense = Expense.create(content: params[:content])
      current_user.expenses << new_expense
    else
      redirect "/balance"
    end
  end
  
  get '/expenses/:id' do
  #   if logged_in?
  #     @user = current_user
  #     erb :"/users/show_expense"
  #   else
  #     redirect "/login"
  #   end
  # end
  
  # get '/tweets/:id/edit' do
  #   if logged_in?
  #     @tweet = Tweet.find(params[:id])
  #     erb :"/tweets/edit_tweet"
  #   else
  #     redirect "/login"
  #   end
  # end
  
  # patch '/tweets/:id/edit' do
  #   tweet = Tweet.find(params[:id])
  #   tweet.content = params[:content]
  #   tweet.save
  # end
  
  # delete '/tweets/:id/delete' do
  #   tweet = Tweet.find(params[:id])
  #   if tweet.user_id == current_user.id
  #     tweet.delete
  #     redirect "/tweets"
  #   end
  #   redirect "/tweets"
  # end
end