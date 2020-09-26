class Question < ActiveRecord::Base
	validates_presence_of :title,:subject_id, :options,:answer,:teacher_id,message:"不能为空"
	validates_inclusion_of :multiple, in: [true,false],message:"只能为'是'或'否'"
	validates_inclusion_of :difficulty,in: 1..10
	validates_length_of :title,minimum: 8,message: "至少要有8位"
	belongs_to :teacher
  belongs_to :subject
	has_and_belongs_to_many :exams
end
