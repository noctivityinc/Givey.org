class Admin::QuestionsController < AdminController
  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
  end

  def new
    @question = Question.new(:active => true)
    @question.backgrounds.build
  end

  def create
    @question = Question.new(params[:question])
    if @question.save
      flash[:notice] = "Successfully created question."
      redirect_to [ :admin, @question ]
    else
      @question.backgrounds.build
      render :action => 'new'
    end
  end

  def edit
    @question = Question.find(params[:id])
    @question.backgrounds.build if @question.backgrounds.empty?
  end

  def update
    @question = Question.find(params[:id])
    if @question.update_attributes(params[:question])
      flash[:notice] = "Successfully updated question."
      redirect_to admin_question_url
    else
      @question.backgrounds.build
      render :action => 'edit'
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    flash[:notice] = "Successfully destroyed question."
    redirect_to admin_questions_url
  end
end
