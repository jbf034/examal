class SubjectsController < BackyardController
  before_action :set_subject, only: [:show, :edit, :update, :destroy]
  before_action :edit_or_delete_right,only:[:edit,:update, :destroy]
  # GET /subjects
  # GET /subjects.json
  def index
    @search = OpenStruct.new params[:search]
    @subjects = Subject.all
    @subjects = build_search(@subjects, @search)
    @subjects = @subjects.paginate(page:params[:page])
  end
  # GET /subjects/1
  # GET /subjects/1.json
  def show
    @subject=Subject.find_by_id(params[:id])
  end

  # GET /subjects/new
  def new
    @subject = Subject.new
  end

  # GET /subjects/1/edit
  def edit
  end

  # POST /subjects
  # POST /subjects.json
  def create
    @subject = current_user.subjects.new(subject_params)
    respond_to do |format|
      if @subject.save
        format.html { redirect_to @subject, notice: "已成功创建学生账户：#{@subject.title}. "}
        format.json { render :show, status: :created, location: @subject }
      else
        format.html { render :new }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subjects/1
  # PATCH/PUT /subjects/1.json
  def update
    unless @edit_or_delete_right
      redirect_to subjects_url,notice:"您没有修改别人编写的试卷的权限"
    end
    respond_to do |format|
      if @subject.update(subject_params)
        format.html { redirect_to subjects_url, notice: "已经成功更新试卷：#{@subject.title}." }
        format.json { render :show, status: :ok, location: subjects_url }
      else
        format.html { render :edit }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subjects/1
  # DELETE /subjects/1.json
  def destroy
    unless @edit_or_delete_right
      redirect_to subjects_url,notice:"您没有删除别人编写的试卷的权限"
    end
    @subject.destroy
    respond_to do |format|
      format.html { redirect_to subjects_url, notice: '已成功删除试卷.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def build_search(records, search)
      records = records.where(name: search.name) if search.name.present?
      records = records.where(profession: search.profession) if search.profession.present?
      records = records.where(grade: search.grade) if search.grade.present?

      records
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def set_subject
      @subject = Subject.find(params[:id])
    end

    def subject_params
      params.require(:subject).permit(:id, :title, :remark, :sex)
    end

    def edit_or_delete_right
        begin
          @edit_or_delete_right=@logged_teacher.is_admin? || @logged_teacher.id==@subject.teacher.id
        rescue Exception => e
          @edit_or_delete_right=nil
        end
        
    end
end
