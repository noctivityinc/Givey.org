class SparksController < ApplicationController
  before_filter :require_user
  before_filter :check_for_end_of_round, :only => [:index]
  before_filter :load_friends, :prepare_sparks, :only => :create
  before_filter :validate_enough_friends, :only => [:index]

  helper_method :sparks_count_display

  def new
    redirect_to sparks_path unless current_user.sparks.empty?
  end

  def create
    render :json => {:status => 'complete', :url => sparks_path}
  end

  def index
    @spark = current_user.get_spark
    redirect_to needs_friends_user_url(current_user) unless @spark
  end

  def update
    # begin
    spark = Spark.find(params[:id])
    spark.update_winner!(params[:uid])
    @spark = current_user.get_spark
    render :json => get_json_response
    # rescue Exception => e
    #   notify_hoptoad(e)
    #   render :json => {:status => "error", :message => e.message}
    # end
  end

  def selected
    render :partial => "shared/sparks", :collection => current_user.sparks.decided.order_by_latest
  end

  def reset
    if !production? && current_user.sparks.destroy_all
      redirect_to sparks_path, :notice => "Sparks reset.  Enjoy."
    else
      redirect_to sparks_path, :notice => "Sorry, reseting sparks failed."
    end
  end

  def defriend
    @spark = current_user.sparks.find_by_id(params[:id])
    if @spark
      @spark.replace_friend(params[:uid]) && @spark.reload
      if current_user.needs_friends?
        current_user.get_friends
        @spark.replace_friend(params[:uid]) && @spark.reload
      end

      if current_user.needs_friends? || @spark.friends.count < 2
        render :json => {:status => "not_enough_friends", :url => user_url(current_user, {:over => 1})}
      else
        render :json => spark_json
      end
    else
      render :json => {:status => "error", :message => "Spark not found for user"}
    end
  end
  
  def end_round
    current_user.update_attribute(:completed_round_one_at, Time.now) unless current_user.completed_round_one_at
  end

  private

    def require_user
      redirect_to root_url, :notice => "Please login to play" unless current_user
    end

    def load_friends
      current_user.destroy_and_get_friends if current_user.friends.active.count < 20 || current_user.friends.outdated?
    end

    def check_for_end_of_round
      redirect_to end_round_sparks_path if current_user.waiting?
    end

    def prepare_sparks
      current_user.prepare_sparks
    end

    def sparks_count_display
      if current_user.sparks.decided.count < 20
        "#{current_user.sparks.decided.count+1} of 20 Qs Needed"
      else
        "#{current_user.sparks.decided.count+1} questions answered"
      end
    end

    def validate_enough_friends
      current_user.get_friends if current_user.needs_friends?
      redirect_to needs_friends_user_url(current_user) if current_user.needs_friends?
    end

    def get_json_response
      return {:status => "not_enough_friends", :url => user_url(current_user, {:over => 1})} unless @spark

      case (current_user.sparks.decided.count + 1)
      when 5 then
        return User.with_causes.empty? ? spark_json : meet_candidate_json.merge!({:spark_resp => spark_json})
      when 10 then
        return what_do_friends_think_json.merge!({:spark_resp => spark_json})
      when 15 then
        your_story_json
      when 16..19
        current_user.npo.blank? ? your_story_json : spark_json
      when 21 then
        end_round_json
      when 22..1001
        current_user.scores_unlocked? ? spark_json : end_round_json
      else
        current_user.waiting? ? end_round_json : spark_json
      end
    end

    def meet_candidate_json
      {:status => "success", :type => 'overlay', :html => render_to_string(:partial => "meet_a_candidate", :locals  => {:candidate => User.random_with_a_story} )}
    end

    def what_do_friends_think_json
      {:status => "success", :type => 'overlay', :html => render_to_string(:partial => "what_do_friends_think")}
    end

    def your_story_json
      {:status => "success", :type => 'modal', :post_url => user_friends_path(current_user), :html => render_to_string(:partial => "your_story")}
    end

    def spark_json
      json = {:status => "success", :type => 'spark', :html => render_to_string(:partial => "/shared/profile", :collection => @spark.friends),
              :question => @spark.question.name, :counts => render_to_string(:partial => "counts"),
              :spark_history => render_to_string(:partial => "shared/sparks", :collection => current_user.sparks.decided.order_by_latest ),
              :background => @spark.question.backgrounds.pick.photo(:normal),
              :candidate_supporter_msg  => render_to_string(:partial => '/shared/candidate_supporter_msg', :locals  => {:candidate => User.random_with_a_cause})}
      json.merge!({:post_url => user_friends_path(current_user)}) if ((current_user.sparks.decided.count + 1) % 21 == 0)
      return json
    end

    def end_round_json
      {:status => "success", :type => "end_round", :url => end_round_sparks_path}
    end

end
