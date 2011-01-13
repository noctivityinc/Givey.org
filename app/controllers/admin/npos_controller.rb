class Admin::NposController < AdminController
  def index
    @npos = Npo.all
  end

  def show
    @npo = Npo.find(params[:id])
  end

  def new
    @npo = Npo.new
  end

  def create
    @npo = Npo.new(params[:npo])
    if @npo.save
      flash[:notice] = "Successfully created npo."
      redirect_to [:admin, @npo]
    else
      render :action => 'new'
    end
  end

  def edit
    @npo = Npo.find(params[:id])
  end

  def update
    @npo = Npo.find(params[:id])
    if @npo.update_attributes(params[:npo])
      flash[:notice] = "Successfully updated npo."
      redirect_to [:admin, @npo]
    else
      render :action => 'edit'
    end
  end

  def destroy
    @npo = Npo.find(params[:id])
    @npo.destroy
    flash[:notice] = "Successfully destroyed npo."
    redirect_to admin_npos_url
  end
end
