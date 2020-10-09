class Exam < ActiveRecord::Base
	validates_presence_of :name,:teacher_id,message:"不能为空"
	validates_uniqueness_of :name,message:"必须是唯一的"
	validates_numericality_of :timespan,message:"应当是一个数字"
	validates_format_of :valid_from,:valid_to,with:/\d{4}-\d{2}-\d{2}/,message:"不是一个合法的日期格式'YYYY-mm-dd hh-MM'"
	belongs_to :teacher
	has_and_belongs_to_many :subjects, :dependent => :destroy
	has_many :contests, :dependent => :destroy
	has_many :students,through: :contests
  has_many :results, :dependent => :destroy

  scope :taken,-> {where('contests.mark is not null')}
  scope :untaken,-> {where('contests.mark is null')}

	def add_subjects_to_result(stu_ids)
		unless id.nil? || stu_ids.blank?
			subjects.each do |sub|
        stu_ids.each do |stu_id|
          Result.create!({student_id: stu_id, subject_id: sub.id, exam_id:id})
        end
			end
		end
	end

	def add_subjects_to_exam(sbs)
		unless id.nil? || sbs.nil?
			sbs.each do |sb|
				subjects << sb 
			end
		else
        errors.add(:考试试卷,"不能为空")
		end
	end

	def add_students_to_exam(ids)
		unless id.nil? || ids.blank?
			  ids.each do |id|
				  contests.create!(student_id: id)
			  end
		end
	end

	def self.get_valid_exam
		Exam.all
	end

  def grade #考试面向的班级
    students.pluck(:grade).uniq
  end
end
