class CreateJoinTableExamSubject < ActiveRecord::Migration
  def change
    create_join_table :exams, :subjects do |t|
      t.index [:exam_id, :subject_id]
      # t.index [:question_id, :exam_id]
    end
  end
end
