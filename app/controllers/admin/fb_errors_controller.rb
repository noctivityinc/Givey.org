class Admin::FbErrorsController < AdminController
  def index
    @fb_errors = FbError.order('created_at desc').all
  end

  def show
    @fb_error = FbError.find(params[:id])
  end

  def destroy
    @fb_error = FbError.find(params[:id])
    @fb_error.destroy
    redirect_to admin_fb_errors_url, :notice => "Successfully destroyed fb error."
  end
end
