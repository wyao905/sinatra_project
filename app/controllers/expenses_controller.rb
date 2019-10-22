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
  
  get '/expenses/new' do
    if logged_in?
      @user = current_user
      erb :"/expenses/new"
    else
      redirect "/"
    end
  end
  
  post '/expenses/new' do
    if params[:date] == "" || params[:amount] == "" || params[:description] == ""
      redirect "/expenses/new"
    else
      date = params[:date].split("-")
      day = date[2]
      month = date[1]
      year = date[0]
      new_expense = Expense.create(day: day, month: month, year: year, description: params[:description], amount: params[:amount])
      current_user.expenses << new_expense
      current_user.balance -= new_expense.amount
      current_user.save
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
  
  patch '/expenses/:id/edit' do
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