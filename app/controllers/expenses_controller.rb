class ExpensesController < ApplicationController
  get '/users/:slug/expenses/new' do
    if logged_in?
      if current_user.slug == params[:slug]
        @user = current_user
        erb :"/expenses/new"
      else
        flash[:message] = "*Access denied."
        redirect "/users/#{current_user.slug}"
      end
    else
      flash[:message] = "*Must be logged in."
      redirect "/"
    end
  end
  
  post '/users/:slug/expenses/new' do
    if params[:date] == "" || params[:amount] == "" || params[:description] == ""
      flash[:message] = "*Missing required field."
      redirect "/users/#{current_user.slug}/expenses/new"
    else
      date = params[:date].split("-")
      day = date[2]
      month = date[1]
      year = date[0]
      new_expense = Expense.create(day: day, month: month, year: year, description: params[:description], amount: params[:amount])
      current_user.expenses << new_expense
      current_user.update(balance: current_user.balance -= new_expense.amount)
      flash[:message] = "*Successfully created expense."
      redirect "/users/#{current_user.slug}"
    end
  end
  
  get '/users/:slug/expenses/week' do
    if logged_in?
      if current_user.slug == params[:slug]
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
      else
        flash[:message] = "*Access denied."
        redirect "/users/#{current_user.slug}"
      end
    else
      flash[:message] = "*Must be logged in."
      redirect "/"
    end
  end
  
  get '/users/:slug/expenses/month' do
    if logged_in?
      if current_user.slug == params[:slug]
        @expenses = []
        @user = current_user
        
        @user.expenses.each do |expense|
          if expense.year == Time.now.year && expense.month == Time.now.month
            @expenses << expense
          end
        end
        
        erb :"/expenses/month_expenses"
      else
        flash[:message] = "*Access denied."
        redirect "/users/#{current_user.slug}"
      end
    else
      flash[:message] = "*Must be logged in."
      redirect "/"
    end
  end
  
  get '/users/:slug/expenses/year' do
    if logged_in?
      if current_user.slug == params[:slug]
        @expenses = []
        @user = current_user
        
        @user.expenses.each do |expense|
          if expense.year == Time.now.year
            @expenses << expense
          end
        end
        
        erb :"/expenses/year_expenses"
      else
        flash[:message] = "*Access denied."
        redirect "/users/#{current_user.slug}"
      end
    else
      flash[:message] = "*Must be logged in."
      redirect "/"
    end
  end
  
  get '/users/:slug/expenses/:id' do
    if logged_in?
      if current_user.slug == params[:slug]
        @expense = Expense.find(params[:id])
        @user = current_user
        @month = month(@expense.month)
        erb :"/expenses/show_expense"
      else
        flash[:message] = "*Access denied."
        redirect "/users/#{current_user.slug}"
      end
    else
      flash[:message] = "*Must be logged in."
      redirect "/"
    end
  end
  
  get '/users/:slug/expenses/:id/edit' do
    if logged_in?
      if current_user.slug == params[:slug]
        @expense = Expense.find(params[:id])
        @user = current_user
        @month = month(@expense.month)
        erb :"/expenses/edit_expense"
      else
        flash[:message] = "*Access denied."
        redirect "/users/#{current_user.slug}"
      end
    else
      flash[:message] = "*Must be logged in."
      redirect "/"
    end
  end
  
  patch '/users/:slug/expenses/:id/edit' do
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
    flash[:message] = "*Successfully updated expense."
    redirect "/users/#{current_user.slug}/expenses/#{expense.id}"
  end
  
  get '/users/:slug/expenses/:id/delete' do
    if logged_in?
      if current_user.slug == params[:slug]
        expense = Expense.find(params[:id])
        current_user.update(balance: current_user.balance += expense.amount)
        expense.delete
        flash[:message] = "*Successfully deleted expense."
        redirect "/users/#{current_user.slug}"
      else
        flash[:message] = "*Access denied."
        redirect "/users/#{current_user.slug}"
      end
    else
      flash[:message] = "*Must be logged in."
      redirect "/"
    end
  end
end