class Exam_Subject < ActiveRecord::Base
	belongs_to :exam
	belongs_to :subject
end
