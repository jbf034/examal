class Subject < ActiveRecord::Base
  belongs_to :teacher
  has_many :questions, :dependent => :destroy
	has_and_belongs_to_many :exams
  has_many :results

  def mentor
    teacher.name
  end
end
