require 'csv' 
class StudentsController < BackyardController
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  # GET /students
  # GET /students.json
  def index
    @search = OpenStruct.new params[:search]
    @students = Student.all
    @students = build_search(@students, @search)
    @students = @students.paginate(page:params[:page])
  end

  # GET /students/1
  # GET /students/1.json
  def show
    @exams=Student.find_by_id(params[:id]).exams
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students
  # POST /students.json
  def create

    @student = current_user.students.new(student_params)
    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, notice: "已成功创建学生账户：#{@student.name}. "}
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice:"已成功更新学生账户：#{@student.name}. "  }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    unless @logged_teacher.is_admin?
      redirect_to students_url,notice:"抱歉，您没有删除学生账户的权限"
      return
    end
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url, notice: '已删除学生账户.' }
      format.json { head :no_content }
    end
  end

  def import
    error = []
    url = params["data_file"].tempfile.path
    csv_text = File.read(url).force_encoding("gbk").encode("utf-8", replace: nil)
    begin
      ActiveRecord::Base.transaction do
        CSV.parse(csv_text, :headers => true) do |row|
          a = row.headers - ["学号", "姓名", "性别", "密码", "年级"]
          raise "不存在#{a.to_s}-标题" unless a.blank?
          Student.create!({teacher_id: current_user.id, stuid: row["学号"], name: row["姓名"], password: row['密码'], sex: row["性别"], grade: row["年级"]})
        end
      end
      redirect_to students_url, notice: '导入成功' and return
    rescue Exception => e
      redirect_to students_url,notice: e.message
    end
  end

  def export 
     send_file("#{Rails.root}/public/template/student.csv",
              filename: "student.csv",
              type: "application/csv")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def build_search(records, search)
      records = records.where(name: search.name) if search.name.present?
      records = records.where(profession: search.profession) if search.profession.present?
      records = records.where(grade: search.grade) if search.grade.present?

      records
    end

    def set_student
      @student = Student.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:stuid, :name, :password, :sex, :profession, :grade)
    end
end
