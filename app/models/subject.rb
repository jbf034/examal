class Subject < ActiveRecord::Base
  belongs_to :teacher
  has_many :questions, :dependent => :destroy
  def mentor
    teacher.name
  end
end
