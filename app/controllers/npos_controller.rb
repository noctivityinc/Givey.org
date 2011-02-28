class NposController < ApplicationController
  def index
    respond_to do |wants|
      wants.html { @npos = Npo.active.featured }
      wants.js { search }
    end
  end
  
  private
  
  def search
    if params[:term] 
      @npos = Npo.where("name ILIKE '%#{params[:term]}%'").limit(20).map {|x| {:value => x.name, :id => x.id}}
      render :json => @npos
    else
      render :json => nil
    end
  end
end
