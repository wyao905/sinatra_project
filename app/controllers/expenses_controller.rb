class ExpensesController < ApplicationController
  get '/balance' do
    if logged_in?
      @user = current_user
      @balance = @user.balance
      erb :"/users/show"
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
    if logged_in?
      @user = current_user
      @expense = Expense.find(params[:id])
      erb :"/users/show_expense"
    else
      redirect "/login"
    end
  end
  
  get '/expenses/:id/edit' do
    if logged_in?
      @expense = Expense.find(params[:id])
      erb :"/expenses/edit_expense"
    else
      redirect "/login"
    end
  end
  
  patch '/expense/:id/edit' do
    expense = Expense.find(params[:id])
    expense.day = params[:day]
    expense.month = params[:month]
    expense.year = params[:year]
    expense.description = params[:description]
    expense.amount = params[:amount]
    expense.save
    redirect "/expenses/#{expense.id}"
  end
  
  delete '/expenses/:id/delete' do
    expense = Expense.find(params[:id])
    if expense.user_id == current_user.id 
      expense.delete
      redirect "/balance"
    end
    redirect "/balance"
  end
end