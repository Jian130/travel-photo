module ApplicationHelper
  
  def nav_link_to(name, options = {})
    classname = "active" if current_page?(options)
    
    content_tag :li, :class => classname do
      link_to name, options
    end
  end
  
  def title
    base_title = "wandereyes"
    unless @title
      "#{t(base_title)} | #{@title}"
    end
  end
end
