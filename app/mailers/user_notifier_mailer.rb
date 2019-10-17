class UserNotifierMailer < ApplicationMailer
	def send_signup_email(user)
    @user = user
    mail( :to => @user.email,
      :subject => 'Thanks for signing up for our amazing app' )
  end

  def send_registration_email(user, password, token)
    @token = token
    @user = user
    mail( :to => @user.email,
      :subject => 'Account Details for Shepherd App',
      :password => password,
      :redirect_url => DeviseTokenAuth.default_password_reset_url,
      :client_config => 'default'

    )
  end
end
