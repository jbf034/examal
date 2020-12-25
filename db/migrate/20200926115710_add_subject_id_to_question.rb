class AddSubjectIdToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :subject_id, :integer
  end
end
