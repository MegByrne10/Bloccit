if Rails.env.development?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    :address => 'smtp.sendgrid.net',
    :port => '587',
    :authentication => :plain,
    :user_name => "app22450359@heroku.com",
    :password => "wfgphf9l",
    :enable_starttls_auto => true
  }
end