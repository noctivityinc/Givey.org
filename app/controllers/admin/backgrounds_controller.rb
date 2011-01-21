class Admin::BackgroundsController < AdminController
  def index
    @backgrounds = Background.all
  end

  def show
    @background = Background.find(params[:id])
  end

  def new
    @background = Background.new
  end

  def create
    @background = Background.new(params[:background])
    if @background.save
      flash[:notice] = "Successfully created background."
      redirect_to [ :admin, @background ]
    else
      render :action => 'new'
    end
  end

  def edit
    @background = Background.find(params[:id])
  end

  def update
    @background = Background.find(params[:id])
    if @background.update_attributes(params[:background])
      flash[:notice] = "Successfully updated background."
      redirect_to admin_background_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @background = Background.find(params[:id])
    @background.destroy
    flash[:notice] = "Successfully destroyed background."
    redirect_to admin_backgrounds_url
  end
end
