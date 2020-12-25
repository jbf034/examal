class UpdateGradeFromStudent < ActiveRecord::Migration[5.0]
  def change
    change_column :students, :grade, :string
  end
end
