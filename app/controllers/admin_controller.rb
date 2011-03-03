class AdminController < ApplicationController
  before_filter :require_admin
  
  def index
  end
  
  def dashboard
    render :partial => "dashboard"
  end
  
end
