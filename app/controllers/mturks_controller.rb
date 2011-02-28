class MturksController < ApplicationController
  def index
    session[:mturk] = true
  end

  def create
    @mturk = Mturk.new(params[:mturk])
    if @mturk.save
      flash[:notice] = "Successfully created mturk."
      redirect_to @mturk
    else
      render :action => 'new'
    end
  end

  def edit
    @mturk = Mturk.find(params[:id])
  end

  def update
    @mturk = Mturk.find(params[:id])
    if @mturk.update_attributes(params[:mturk])
      flash[:notice] = "Successfully updated mturk."
      redirect_to mturk_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @mturk = Mturk.find(params[:id])
    @mturk.destroy
    flash[:notice] = "Successfully destroyed mturk."
    redirect_to mturks_url
  end
end
