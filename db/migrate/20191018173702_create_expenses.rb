class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.integer :day
      t.integer :month
      t.integer :year
      t.string :description
      t.float :amount
    end
  end
end
