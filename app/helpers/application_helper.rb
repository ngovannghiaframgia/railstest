module ApplicationHelper
  def full_title(page_title = "")
  	base_title = t "Ruby_on_Rails_Tutorial_Sample_App"
  	if page_title.empty?
  		base_title
  	else
  		page_title + " | " + base_title
  	end
  end
end
