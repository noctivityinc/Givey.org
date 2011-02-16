# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  def title(page_title, show_title = true)
    content_for(:title) { h(page_title.to_s) }
    @show_title = show_title
  end

  def show_title?
    @show_title
  end
  
  def show_top_nav(val)
    @top_nav = val
  end
  
  def show_top_navs?
    return @top_nav.nil? ?  true : @top_nav
  end
  
  def hide_login_info
    @hide_login_info = true
  end
  
  def hide_login_info?
    @hide_login_info
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
end
