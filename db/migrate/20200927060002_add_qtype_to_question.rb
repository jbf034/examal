class AddQtypeToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :qtype, :integer
  end
end
