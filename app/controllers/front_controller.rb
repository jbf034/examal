class FrontController < ApplicationController
  before_action :authorize
  before_action :set_logged_student
  layout "panel"
  def logged_student
    student = Student.find_by_id(session[:student_id])
    if student.blank?
      student = Student.find_by_stuid(params["stuid"])
      if student.blank?
        grade = Time.now.year - params["grade"].to_i + 1
        teacher = Teacher.first
        student = Student.create!({stuid: params["stuid"], grade: grade, name: params["name"], password: "123456", teacher_id: teacher.id})
        add_subject(student)
      end
    end
    session[:student_id] = student.id
    student
  end

  protected
  def authorize
    unless !(session[:student_id].nil?) && Student.find_by_id(session[:student_id])
      respond_to do |format|
        format.html {redirect_to index_url,alert:"请登录后再使用本系统"}
        format.json {render json: {code: 403,message:"请登录后再使用本系统",message_en:"You Are Not authorized to access before log in"}, status: :forbidden}
      end
      return 
    end
  end
  def set_logged_student
    @logged_student=logged_student
  end

  def add_subject(student)
    Exam.all.each do |e|
      subjects = e.subjects
      grades = e.grade
      if grades.include?(student.grade)
        e.add_students_to_exam([student.id])
        e.add_subjects_to_result([student.id])
      end
    end
  end
end
