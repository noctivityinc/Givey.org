class NposController < ApplicationController
  def index
    if params[:term] 
      @npos = Npo.where("name ILIKE '%#{params[:term]}%'").limit(20).map {|x| {:value => x.name, :id => x.id}}
      render :json => @npos
    else
      render :json => nil
    end
  end
end
