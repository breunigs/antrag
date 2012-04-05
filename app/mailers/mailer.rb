class Mailer < ActionMailer::Base
  default :from => "antrag@fsk.uni-heidelberg.de"

  # >>> Mailer.antrag(referat oder so, antragsteller, antrag-id)
  def antrag(mail, submitter, antrag_id = "0")
    @greeting = "Hi"

    # add header to be able to link this mail to a certain Antrag
    # automatically
    headers["X-Antrag-ID"] = antrag_id

    # send mails manually for each mail so that reply-to simply works
    mail(:to => submitter, :subject => "Neuer Antrag (Kopie)", :reply_to => [mail, "antrag@fsk.uni-heidelberg.de"]).deliver
    mail(:to => mail, :subject => "Neuer Antrag", :reply_to => [submitter, "antrag@fsk.uni-heidelberg.de"]).deliver
  end
end
