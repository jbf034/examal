class AddQtypeToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :qtype, :integer
  end
end
