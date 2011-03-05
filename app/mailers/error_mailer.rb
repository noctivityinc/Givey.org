class ErrorMailer < ActionMailer::Base
  default :from => "give@givey.org"

  def facebook_error(result)
    @result = result
    mail(:to => "Josh Lippiner <josh@givey.org>", :subject => "Givey Facebook Error: #{@result.code}")
  end
end
