class CampaignsController < ApplicationController
  before_filter :login_user, :only => [:new, :friends]
  before_filter :require_user
  before_filter :get_campaign, :validate_user, :except => [:new, :create]

  def new
    @campaign = Campaign.new({:givey_tip => true})
    @campaign.givey_tip = true
    session[:campaign_id_waiting] = nil
  end

  def create
    @campaign = Campaign.new(params[:campaign])
    @campaign.user = current_user
    if @campaign.save # => makes sure they didnt refresh the page to generate a new campaign
      session[:campaign_id_waiting] = @campaign.id
      redirect_to friends_campaign_path(@campaign)
    else
      render :action => 'new', :alert => @campaign.errors.full_messages.join(', ')
    end
  end

  def edit
  end

  def update
    if @campaign.update_attributes(params[:campaign])
      flash[:notice] = "Successfully updated campaign."
      redirect_to @campaign
    else
      render :action => 'edit'
    end
  end

  def destroy
    @campaign.destroy
    flash[:notice] = "Successfully destroyed campaign."
    redirect_to campaigns_url
  end

  def friends
    @all_friends ||= @fb.fql("SELECT uid, name, pic_square FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me())")
    available_friends = @all_friends.count
    @number_of_friends_to_select = @campaign.slots_available * 3
    @number_of_friends_to_select = available_friends if @number_of_friends_to_select > available_friends

    if @campaign.friends_hash && @campaign.friends_hash.count > 0
      @friend_list = @campaign.friends_hash
    else
      1.upto(@number_of_friends_to_select) do
        (@friend_list ||= []) << @all_friends[rand(available_friends)]
        update_friends_hash
      end
    end
  end

  def remove_friend
    @friend_list = @campaign.friends_hash
    @friend_list.reject! {|x| x.uid.to_s == params[:uid].to_s}
    update_friends_hash
    render :partial => "friend_list", :collection => @friend_list
  end

  def add_friend
    @friend_list = @campaign.friends_hash
    @friend_list << Hashie::Mash.new(params[:u])
    update_friends_hash
    render :partial => "friend_list", :collection => @friend_list
  end
  
  def friend_search
    @fb ||= MiniFB::OAuthSession.new(current_user.token)
    res = @fb.fql("SELECT uid, name, pic_square FROM user WHERE strpos(name,'#{params[:q]}') > 0 AND uid IN (SELECT uid2 FROM friend WHERE uid1 = me())")
    render :json => res
  end

  def paypal_redirect
    if @campaign.friends_hash.count < @campaign.slots_available
      redirect_to friends_campaign_path(@campaign), :alert => "You haven't selected enough friends.  Let's try again."
    end
  end

  private

    def require_user
      redirect_to root_url, :notice => "You must be logged into facebook to create an experiment." unless current_user
    end
    
    def validate_user
      redirect_to new_campaign_path, :notice => "Why not start your own experiment!?" unless @campaign.user == current_user
    end

    def login_user
      if current_user
        @fb ||= MiniFB::OAuthSession.new(current_user.token)
        begin
          x = @fb.fql("SELECT uid, name, pic_square FROM user WHERE uid = me()")
        rescue Exception => e
          cookies[:user_id] = {:value => nil}
          redirect_to root_url, :notice => "You must be logged into facebook to create an experiment."
        end
      else
        redirect_to root_url, :notice => "You must be logged into facebook to create an experiment."
      end
    end

    def get_campaign
      @campaign = Campaign.find(params[:id]) rescue nil
      redirect_to new_campaign_url, :notice => "Please try again..." unless @campaign
    end

    def update_friends_hash
      @campaign.update_attributes!(:friends_hash => @friend_list)
    end

end
