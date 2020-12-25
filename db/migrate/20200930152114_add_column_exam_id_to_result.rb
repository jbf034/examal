class AddColumnExamIdToResult < ActiveRecord::Migration[5.0]
  def change
    add_column :results, :exam_id, :integer
  end
end
