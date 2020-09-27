class Exam < ActiveRecord::Base
	validates_presence_of :name,:teacher_id,message:"不能为空"
	validates_uniqueness_of :name,message:"必须是唯一的"
	validates_numericality_of :timespan,message:"应当是一个数字"
	validates_format_of :valid_from,:valid_to,with:/\d{4}-\d{2}-\d{2}/,message:"不是一个合法的日期格式'YYYY-mm-dd hh-MM'"
	belongs_to :teacher
	has_and_belongs_to_many :questions
	has_many :contests
	has_many :students,through: :contests
	def add_questions_to_exam(qsts)
		byebug
		unless id.nil? || qsts.nil?
			qsts.each do |question|
				questions<<question
			end
		else
        errors.add(:题目列表,"不能为空")
		end
	end

	def add_students_to_exam(student_ids)
		unless id.nil?
			student_ids.each do |student_id|
				contests<<student_id
			end
		end
	end

	def self.get_valid_exam
		Exam.all
	end
end
