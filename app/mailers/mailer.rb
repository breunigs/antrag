class Mailer < ActionMailer::Base
  default :from => "from@example.com"

  # >>> Mailer.antrag(referat oder so, antragsteller)
  def antrag(mail, cc)
    @greeting = "Hi"

    mail(:to => mail, :cc => cc, :subject => "Neuer Antrag", :reply_to => [mail, cc])
  end
end
