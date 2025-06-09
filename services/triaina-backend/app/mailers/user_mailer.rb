class UserMailer < ApplicationMailer
    default from: ENV["SMTP_USERNAME"] # or your actual domain

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to Triaina")
  end
end
