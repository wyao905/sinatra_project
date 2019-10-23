class ExpensesController < ApplicationController
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
      current_user.update(balance: current_user.balance -= new_expense.amount)
      redirect "/users/#{current_user.slug}"
    end
  end
  
  get '/expenses/:id' do
    @expense = Expense.find(params[:id])
    
    if logged_in? && current_user.id == @expense.user_id
      @user = current_user
      case @expense.month
      when 1
        @month = "January"
      when 2
        @month = "February"
      when 3
        @month = "March"
      when 4
        @month = "April"
      when 5
        @month = "May"
      when 6
        @month = "June"
      when 7
        @month = "July"
      when 8
        @month = "August"
      when 9
        @month = "September"
      when 10
        @month = "October"
      when 11
        @month = "November"
      else
        @month = "December"
      end
      erb :"/expenses/show_expense"
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
  
  get '/expenses/:id/delete' do
    expense = Expense.find(params[:id])
    if logged_in? && current_user.id == expense.user_id
      current_user.update(balance: current_user.balance += expense.amount)
      expense.delete
      redirect "/users/#{current_user.slug}"
    end
    redirect "/users/#{current_user.slug}"
  end
end