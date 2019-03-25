class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t(" mailers.user.subject")
  end

  def password_reset
    @greeting = t(" mailers.user.greeting")
    mail to: "to@example.org"
  end
end
