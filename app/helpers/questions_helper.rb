module QuestionsHelper
	def difficulty_level(number)
		if number.in?(1..2)
			content_tag :span,number.to_s+"-入门",:class=>"label label-default"
		elsif number.in?(2..4)
			content_tag :span,number.to_s+"-简单",:class=>"label label-success"
		elsif number.in?(4..6)
			content_tag :span,number.to_s+"-普通",:class=>"label label-info"
		elsif number.in?(6..8)
			content_tag :span,number.to_s+"-稍难",:class=>"label label-warning"
		elsif number.in?(6..10)
			content_tag :span,number.to_s+"-困难",:class=>"label label-important"
		else
			content_tag :span,number.to_s,:class=>"label label-default"
		end
	end

  def qtype_level(number)
		if number == 1
			content_tag :span,number.to_s+"单选",:class=>"label label-success small"
		elsif number == 2
			content_tag :span,number.to_s+"多选",:class=>"label label-success"
    elsif number == 3
			content_tag :span,number.to_s+"判断",:class=>"label label-success"
    else
			content_tag :span,number.to_s,:class=>"label label-success"
    end
  end

end
