require 'csv' 
require 'fileutils'
class QuestionsController < BackyardController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :edit_or_delete_right,only:[:edit,:update, :destroy]
  # GET /questions
  # GET /questions.json
  def index
    @questions = Question.order(updated_at: :desc).paginate(page:params[:page])
  end

  # GET /questions/1
  # GET /questions/1.json
  # GET /questions/1.js
  def show
  end

  # GET /questions/new
  def new
    @subjects = current_user.subjects
    @question = Question.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /questions/1/edit
  def edit
    @subjects = current_user.subjects
    unless @edit_or_delete_right
      redirect_to questions_url,notice:"您没有修改别人编写的题目的权限"
    end
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(question_params)
    respond_to do |format|
      if @question.save
        format.html { redirect_to new_question_url, notice: "已经成功创建题目：#{@question.title}." }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    unless @edit_or_delete_right
      redirect_to questions_url,notice:"您没有修改别人编写的题目的权限"
    end
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to questions_url, notice: "已经成功更新题目：#{@question.title}." }
        format.json { render :show, status: :ok, location: questions_url }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    unless @edit_or_delete_right
      redirect_to questions_url,notice:"您没有删除别人编写的题目的权限"
    end
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url, notice: '已成功删除题目.' }
      format.json { head :no_content }
    end
  end

  def import
    error = []
    url = params["data_file"].tempfile.path
    subject_id = params["subject_id"]
    csv_text = File.read(url).force_encoding("gbk").encode("utf-8", replace: nil)
    begin
      ActiveRecord::Base.transaction do
        CSV.parse(csv_text, :headers => true) do |row|
          a = row.headers - ["类型","题目","题目描述","选项","答案"]
          raise '标题有问题' unless a.blank?
          Question.create!({teacher_id: current_user.id, subject_id: subject_id, qtype: row["类型"], title: row["题目"], description: row['题目描述'], options: row["选项"], answer: row["答案"]})
        end
      end
      redirect_to subject_path(subject_id), notice: '导入成功' and return
    rescue Exception => e
      redirect_to subject_path(subject_id),notice: e.message
    end
  end

  def export 
     send_file("#{Rails.root}/public/template/questions.csv",
              filename: "questions.csv",
              type: "application/csv")
  end
#上传图片
  def upload
    url = params["uploadImage"].tempfile.path
    filename = params["uploadImage"].original_filename
    image = MiniMagick::Image.open(url)
    image.resize "200"
    filename =  "#{current_user.id}_#{filename}"
    d_file = "#{Rails.root}/public/tmp/#{filename}"
    FileUtils.mv(image.path, d_file)
    render json: {result:{returnData: {url: "tmp\/#{filename}"}}}
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      prm=params.require(:question).permit(:title, :subject_id, :qtype, :description, :options,  :difficulty,answer: [])
      prm[:teacher_id]=@logged_teacher.id
      answer=""
      count=0
      prm[:answer].each{ |x|
        unless x.empty?
          answer+=x.to_s.strip+","
          count+=1
        end
      }
      prm[:answer]=answer
      prm[:multiple]=true if count>1
      return prm
    end
    def edit_or_delete_right
        begin
          @edit_or_delete_right=@logged_teacher.is_admin? || @logged_teacher.id==@question.teacher.id
        rescue Exception => e
          @edit_or_delete_right=nil
        end
        
    end
end
