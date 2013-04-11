class UserMailer < ActionMailer::Base
  layout 'email'
  default :from => 'Project October <no-reply@october.case.edu>'

  def welcome_email(user)
    @user = user
    mail :to => user.email, :subject => 'Welcome to Project October!'
  end
end
