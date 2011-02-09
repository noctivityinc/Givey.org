class SparksController < ApplicationController
  before_filter :require_user
  before_filter :load_friends, :only => :create
  
  helper_method :sparks_count_display

  def create
    render :json => {:status => 'complete', :url => sparks_path}
  end

  def index
    @spark = current_user.prepare_a_spark
  end

  def update
    spark = Spark.find(params[:id])
    spark.update_attributes(:winner_uid => params[:uid])
    @spark = current_user.prepare_a_spark
    render :json => {:status => 'spark', :html => render_to_string(:partial => "friend", :collection => @spark.friends), 
                    :question => @spark.question.name, :counts => sparks_count_display,
                    :selected_list => render_to_string(:partial => "selected_list")}
  end
  
  def selected
    render :partial => "selected_list"
  end

  private

    def require_user
      redirect_to root_url, :notice => "Please login to play" unless current_user
    end

    def load_friends
      current_user.destroy_and_get_friends if current_user.friends.count < 20 || current_user.friends_outdated?
    end

    def sparks_count_display
      "#{current_user.sparks.decided.count + 1} / #{current_user.sparks.goal}"
    end

end
