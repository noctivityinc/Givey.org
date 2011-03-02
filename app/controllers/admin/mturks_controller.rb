class Admin::MturksController < AdminController
  def index
    @mturks = Mturks.all
  end

  def show
    @mturks = Mturks.find(params[:id])
  end
end
