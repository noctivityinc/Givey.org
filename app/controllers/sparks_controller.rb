class SparksController < ApplicationController
  before_filter :require_user
  before_filter :load_friends, :only => :create

  helper_method :sparks_count_display

  def new
    redirect_to sparks_path unless current_user.sparks.empty?
  end

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
    render :json => get_json_response
  end

  def selected
    render :partial => "selected_list"
  end

  private

    def require_user
      redirect_to root_url, :notice => "Please login to play" unless current_user
    end

    def load_friends
      current_user.destroy_and_get_friends if current_user.friends.count < 20 || current_user.friends.outdated?
    end

    def sparks_count_display
      "#{current_user.sparks.decided.count + 1} / #{current_user.sparks.goal}"
    end

    def get_json_response
      case (current_user.sparks.decided.count + 1)
      when 5 then
        return User.candidates.empty? ? spark_json : meet_candidate_json.merge!({:spark_resp => spark_json})
      when 10 then
        return what_do_friends_think_json.merge!({:spark_resp => spark_json})
      when 20 then
        your_story_json
      when 21..1000 then
        current_user.candidates_story.blank? ? your_story_json : spark_json
      else
        spark_json
      end
    end

    def meet_candidate_json
      {:status => 'overlay', :html => render_to_string(:partial => "meet_a_candidate", :locals  => {:candidate => User.random_candidate} )}
    end

    def what_do_friends_think_json
      {:status => 'overlay', :html => render_to_string(:partial => "what_do_friends_think")}
    end

    def your_story_json
      {:status => 'modal', :post_url => user_friends_path(current_user), :html => render_to_string(:partial => "your_story")}
    end

    def spark_json
      json = {:status => 'spark', :html => render_to_string(:partial => "profile", :collection => @spark.friends),
              :question => @spark.question.name, :counts => sparks_count_display,
              :selected_list => render_to_string(:partial => "selected_list"),
              :background => @spark.question.backgrounds.pick.photo(:normal),
              :candidate_supporter_msg  => render_to_string(:partial => '/layouts/candidate_supporter_msg', :locals  => {:candidate => User.random_candidate})}
      json.merge!({:post_url => user_friends_path(current_user)}) if ((current_user.sparks.decided.count + 1) % 20 == 0)
      return json
    end

end