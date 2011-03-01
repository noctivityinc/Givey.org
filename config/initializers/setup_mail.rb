ActionMailer::Base.smtp_settings = {
  :address              => "mail.blueboxgrid.com",
  :port                 => 2500,
  :domain               => "givey.org",
  :user_name            => "give@givey.org",
  :password             => "4ax52givey",
  :authentication       => :login,
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = APP_CONFIG[:domain]
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?

