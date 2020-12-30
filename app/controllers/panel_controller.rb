class PanelController < FrontController
	layout "wechat" ,only: [:wechat_exam, :wechat_index, :wechat_check]
  skip_before_action :authorize, only: %w[wechat_index wechat_exam]
  def index
    @exams=@logged_student.exams.taken
    @average=0
    now=Time.now+8*3600
    @taken_subjects = @logged_student.results.where("exam_id in (?)", @exams.ids)
    @taken_subjects.each do |result|
      @average+=result.mark
    end

    @average = @average / (@taken_subjects.blank? ? 1 : @taken_subjects.size)
  	@current = @logged_student.exams.where("valid_from <= ? and valid_to >= ?",now,now)
  end

  def taken
    @exams=@logged_student.exams.taken
  end

  def untaken
  	now=Time.now+8*3600
  	@current=@logged_student.exams.untaken.where("valid_from <= ? and valid_to >= ?",now,now)
  	@not_ready=@logged_student.exams.where("valid_from > ?",now)
  	@old=@logged_student.exams.where("valid_to < ?",now)
  end

  def info
  	@student=@logged_student
  end

  def exam #开始考试
  	student=@logged_student
  	unless student.results.find_by_subject_id(params[:subject_id]).mark.nil?
  		redirect_to panel_untaken_url,notice:"您已经参加过这门考试"
  	end
  	begin
      @exam = student.exams.find_by_id(params[:id])
  		@subject = @exam.subjects.find(params[:subject_id])
  	rescue Exception => e
  		redirect_to panel_untaken_url,notice:"没有找到这门考试"
  	end

  end

  def check
  	student=@logged_student
  	@answer=params[:answer]

  	unless student.results.find_by_subject_id(params[:subject_id]).mark.nil?
  		redirect_to panel_untaken_url,notice:"您已经参加过这门考试"
  		return 
  	end
  	begin
  		subject=Subject.find(params[:subject_id])
      result = student.results.find_by_subject_id(params[:subject_id])
  	rescue Exception => e
  		redirect_to panel_untaken_url,notice:"没有找到这门考试"
  		return
  	end
  	@count=0
  	@right=0
  	@fault=0
  	@right_questions=[]
  	@fault_questions=[]
  	subject.questions.each do |question|
  		@count+=1
  		if value=@answer[question.id.to_s]
  			true_answer=question.answer.split(",")
  			common=true_answer&value
  			if common.size==true_answer.size
  				@right+=1
  				@right_questions<<{question: question ,answer: value}
  			else
  				@fault+=1
  				@fault_questions<<{question: question ,answer: value}
  			end
  		else
  			@fault+=1
  			@fault_questions<<{question: question ,answer: [""]}
  		end
  	end
  	@mark=@right*100/@count
  	result.update({mark: @mark}) #试卷分数
    exam = Exam.find(params[:id])
    current_contest = student.contests.find_by_exam_id(params[:id]) #当前考试

    current_subjects = student.results.where("subject_id in (?) and exam_id = ?", exam.subjects.ids, params[:id])
    count_mark = current_subjects.pluck(:mark) #所有试卷分数组

    if count_mark.compact!.nil? 
      count_subjects_num = count_mark.sum 
    elsif count_mark.size > 0
      count_subjects_num = count_mark.compact!.sum 
    end
    current_contest.update({mark: count_subjects_num})
  end

  def wechat_exam #开始考试
  	student=@logged_student

  	unless true || student.results.find_by_subject_id(params[:subject_id]).mark.nil?
  		redirect_to panel_wechat_index_url,notice:"您已经参加过这门考试"
  	end
  	begin
      @exam = student.exams.find_by_id(params[:id])
  		@subject = @exam.subjects.find(params[:subject_id])
  	rescue Exception => e
  		redirect_to panel_wechat_index_url,notice:"没有找到这门考试"
  	end
  end

  def wechat_index
    @exams=@logged_student.exams.taken
    @average=0
    now=Time.now+8*3600
    @taken_subjects = @logged_student.results.where("exam_id in (?)", @exams.ids)
    @taken_subjects.each do |result|
      @average+=result.mark
    end
    @average = @average / (@taken_subjects.blank? ? 1 : @taken_subjects.size)
  	@current = @logged_student.exams.where("valid_from <= ? and valid_to >= ?",now,now)
  end

  def wechat_check
  	student=@logged_student
  	@answer=params[:answer]

  	unless true || student.results.find_by_subject_id(params[:subject_id]).mark.nil?
  		redirect_to panel_untaken_url,notice:"您已经参加过这门考试"
  		return 
  	end

  	begin
  		subject=Subject.find(params[:subject_id])
      result = student.results.find_by_subject_id(params[:subject_id])
  	rescue Exception => e
  		redirect_to panel_untaken_url,notice:"没有找到这门考试"
  		return
  	end
  	@count=0
  	@right=0
  	@fault=0
  	@right_questions=[]
  	@fault_questions=[]
  	subject.questions.each do |question|
  		@count+=1
  		if value=@answer[question.id.to_s]
  			true_answer=question.answer.split(",")
  			common=true_answer&value
  			if common.size==true_answer.size
  				@right+=1
  				@right_questions<<{question: question ,answer: value}
  			else
  				@fault+=1
  				@fault_questions<<{question: question ,answer: value}
  			end
  		else
  			@fault+=1
  			@fault_questions<<{question: question ,answer: [""]}
  		end
  	end
  	@mark=@right*100/@count
  	result.update({mark: @mark}) #试卷分数
    exam = Exam.find(params[:id])
    current_contest = student.contests.find_by_exam_id(params[:id]) #当前考试

    current_subjects = student.results.where("subject_id in (?) and exam_id = ?", exam.subjects.ids, params[:id])
    count_mark = current_subjects.pluck(:mark) #所有试卷分数组

    if count_mark.compact!.nil? 
      count_subjects_num = count_mark.sum 
    elsif count_mark.size > 0
      count_subjects_num = count_mark.compact!.sum 
    end
    current_contest.update({mark: count_subjects_num})
  end
end
