class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    user.update_with_omniauth(auth) # => updates to make sure we have latest session key and profile info
    cookies[:user_id] = {:value => user.id, :expires => 24.hours.from_now }
    redirect_to root_url, :notice => "Signed in!"
  end

  def destroy
    cookies[:user_id] = {:value => nil}
    redirect_to root_url, :notice => "Signed out!"
  end
end
