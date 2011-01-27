class Admin::BetaTestersController < ApplicationController
  def index
    @beta_testers = BetaTester.all
  end

  def show
    @beta_tester = BetaTester.find(params[:id])
  end

  def new
    @beta_tester = BetaTester.new
  end

  def create
    @beta_tester = BetaTester.new(params[:beta_tester])
    if @beta_tester.save
      flash[:notice] = "Successfully created beta tester."
      redirect_to [ :admin, @beta_tester ]
    else
      render :action => 'new'
    end
  end

  def edit
    @beta_tester = BetaTester.find(params[:id])
  end

  def update
    @beta_tester = BetaTester.find(params[:id])
    if @beta_tester.update_attributes(params[:beta_tester])
      flash[:notice] = "Successfully updated beta tester."
      redirect_to admin_beta_tester_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @beta_tester = BetaTester.find(params[:id])
    @beta_tester.destroy
    flash[:notice] = "Successfully destroyed beta tester."
    redirect_to admin_beta_testers_url
  end
end
