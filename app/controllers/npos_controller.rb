class NposController < ApplicationController
  def index
    respond_to do |wants|
      wants.html { @npos = Npo.active.featured }
      wants.js { search }
    end
  end
  
  def top
    users = User.scorable.with_causes.limit(10)
    @npo_ids = {}
    users.each {|x| 
      @npo_ids[x.npo_id] += x.score if x.score
    }
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
