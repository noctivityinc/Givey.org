class HomeController < ApplicationController
  def index
    if current_user
      @fb = MiniFB::OAuthSession.new(current_user.token, 'es_ES')
      begin
        @res = @fb.fql("SELECT uid, name, pic_square FROM user WHERE uid = me() OR uid IN (SELECT uid2 FROM friend WHERE uid1 = me())")
      rescue Exception => e
        cookies[:user_id] = {:value => nil}
      end

      # @fb.post('me', :type => :feed, :params => {
      #   :message => "This is me from MiniFB at #{Time.now.to_s}"
      # })

      # @fb.post('me', :type => :feed, :params => {
      #            :link => 'http://www.givey.org',
      #            :name => "#{current_user.name}'s Givey Experiment",
      #            :caption => "Givey Experiment posted at #{Time.now.to_s}",
      #            :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      #            :message => "This is something Im trying."
      # })
    end
  end

end
