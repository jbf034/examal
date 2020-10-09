class Result < ActiveRecord::Base
	validates :student_id, uniqueness: {scope: :subject_id, message:"此学生已经分发过此试卷"}
  belongs_to :student
  belongs_to :subject
  belongs_to :exam
end
