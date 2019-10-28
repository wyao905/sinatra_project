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
  
  get '/expenses/week' do
    @expenses = []
    @user = current_user
    norm_time = Time.new(Time.now.year, Time.now.month, Time.now.day)
    sunday_point = norm_time - (86400 * norm_time.wday)
    
    Expense.all.each do |expense|
      exp_time = Time.new(expense.year, expense.month, expense.day)
      if exp_time - sunday_point >= 0
        @expenses << expense
      end
    end
    
    erb :"/expenses/week_expenses"
  end
  
  get '/expenses/month' do
    erb :"/expenses/month_expenses"
  end
  
  get '/expenses/year' do
    erb :"/expenses/year_expenses"
  end
  
  get '/expenses/:id' do
    @expense = Expense.find(params[:id])
    
    if logged_in? && current_user.id == @expense.user_id
      @user = current_user
      @month = month(@expense.month)
      erb :"/expenses/show_expense"
    else
      redirect "/login"
    end
  end
  
  get '/expenses/:id/edit' do
    @expense = Expense.find(params[:id])
    if logged_in? && current_user.id == @expense.user_id
      @user = current_user
      @month = month(@expense.month)
      erb :"/expenses/edit_expense"
    else
      redirect "/login"
    end
  end
  
  patch '/expenses/:id/edit' do
    expense = Expense.find(params[:id])
    current_user.update(balance: current_user.balance += expense.amount)
    if params[:date] != ""
      date = params[:date].split("-")
      new_day = date[2]
      new_month = date[1]
      new_year = date[0]
      expense.day = new_day
      expense.month = new_month
      expense.year = new_year
    end
    expense.description = params[:description] if params[:description] != ""
    expense.amount = params[:amount] if params[:amount] != ""
    expense.save
    current_user.update(balance: current_user.balance -= expense.amount)
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