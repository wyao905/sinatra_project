class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.string :date
      t.string :description
      t.float :amount
    end
  end
end
