class ExamsController < BackyardController
  before_action :set_exam, only: [:show, :edit, :update, :destroy]
  before_action :set_question,only:[:new,:edit,:create,:update]
  before_action :edit_or_delete_right,only:[:edit, :update, :destroy]
  # GET /exams
  # GET /exams.json
  def index
    @exams = Exam.order(created_at: :desc).all
  end

  # GET /exams/1
  # GET /exams/1.json
  def show
    
  end

  # GET /exams/new
  def new
    @grade = current_user.students.pluck(:grade).uniq
    @subjects = current_user.subjects.select(:id, :title)
    @students = Student.where("grade in (?)", params["grade"])

    @exam = Exam.new   
  end

  def optbox
    @question=Question.find_by_id(params[:id])
    respond_to do |format|
      format.js
    end
  end
  # GET /exams/1/edit
  def edit
    unless @edit_or_delete_right
      redirect_to exams_url,notice:"您无权修改别人编写的考试"
    end
    @grade = current_user.students.pluck(:grade).uniq
    @subjects = current_user.subjects.select(:id, :title)
    @students = Student.where("grade in (?)", params["grade"])
  end

  # POST /exams
  # POST /exams.json
  def create
    grades = params["grade"]
    subjects = params["subject"]
    @exam = Exam.new(exam_params)
    result=@exam.save

    @students = Student.where("grade in (?)", grades)
    @subjects = current_user.subjects.where("id in (?)", subjects)

    @exam.add_students_to_exam(@students)
    @exam.add_subjects_to_exam(@subjects)
    #@exam.add_questions_to_exam(@validated_question) #考试题目
    respond_to do |format|
      if result
        format.html { redirect_to @exam, notice: "已成功建立考试“#{@exam.name}.”" }
        format.json { render :show, status: :created, location: @exam }
      else
        format.html { render :new }
        format.json { render json: @exam.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exams/1
  # PATCH/PUT /exams/1.json
  def update
    unless @edit_or_delete_right
      redirect_to exams_url,notice:"您无权修改别人编写的考试" and return 
    end

    parsed_param=exam_params

    grades = params["grade"]
    @exam.contests.delete_all
    @students = Student.where("grade in (?)", params["grade"])
    @exam.add_students_to_exam(@students)

    subjects = params["subject"]
    @exam.subjects.delete_all
    @subjects = current_user.subjects.where("id in (?)", subjects)
    @exam.add_subjects_to_exam(@subjects)

#    @exam.questions.delete_all
#    @exam.add_questions_to_exam(@validated_question)
    respond_to do |format|
      if @exam.update(parsed_param)
        format.html { redirect_to @exam, notice: "已成功更新考试“#{@exam.name}.”" }
        format.json { render :show, status: :ok, location: @exam }
      else
        format.html { render :edit }
        format.json { render json: @exam.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exams/1
  # DELETE /exams/1.json
  def destroy
    unless @edit_or_delete_right
      redirect_to exams_url,notice:"您无权删除别人编写的考试" and return
    end
    @exam.destroy
    respond_to do |format|
      format.html { redirect_to exams_url, notice: '成功删除考试.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exam
      @exam = Exam.find(params[:id])
    end

    def set_question
      @questions= Question.order(updated_at: :desc).all
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def exam_params
      prm=params.require(:exam).permit(:name, :description, :valid_from, :valid_to, :timespan, :teacher_id)
      questions=params.permit(question_list: [])
      prm[:teacher_id]=@logged_teacher.id
      @validated_question=[]
      unless questions["question_list"].nil?
        sum=0
        questions["question_list"].each do |question_id|
          question=Question.find_by_id(question_id)
          unless question.nil?
            @validated_question << question
            sum+=question.difficulty
          end
        end
        prm[:average_difficulty]=sum.to_f/@validated_question.size.to_f

      end
      prm
    end

    def edit_or_delete_right
        @edit_or_delete_right=current_user.is_admin? || current_user.id == @exam.teacher.id
    end
end
