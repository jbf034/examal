class UpdateGradeFromStudent < ActiveRecord::Migration
  def change
    change_column :students, :grade, :string
  end
end
