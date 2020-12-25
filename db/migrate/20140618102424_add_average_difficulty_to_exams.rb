class AddAverageDifficultyToExams < ActiveRecord::Migration[5.0]
  def change
    add_column :exams, :average_difficulty, :decimal,precision: 5, scale: 2
  end
end
