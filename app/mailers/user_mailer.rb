class UserMailer < ActionMailer::Base
  default :from => "give@givey.org"
  
  def welcome(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Welcome to Givey.org")
  end
    
  def invite_friend_reminder(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "You need more friends on Givey")
  end

  def scores_unlocked(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Givey scores unlocked!")
  end
end
