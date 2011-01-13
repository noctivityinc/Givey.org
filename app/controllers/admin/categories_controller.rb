class Admin::CategoriesController < AdminController
  def index
    @categories = Category.all
  end
  
  def show
    @category = Category.find(params[:id])
  end
  
  def new
    @categories = Category.all
    @category = Category.new(:active => true)
  end
  
  def create
    @category = Category.new(params[:category])
    if @category.save
      flash[:notice] = "Successfully added #{@category.name}."
      redirect_to new_admin_category_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @category = Category.find(params[:id])
  end
  
  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      flash[:notice] = "Successfully updated category."
      redirect_to admin_category_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    flash[:notice] = "Successfully removed #{@category.name}."
    redirect_back
  end
end
