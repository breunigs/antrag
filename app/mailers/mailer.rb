# encoding: utf-8

class Mailer < ActionMailer::Base
  default :from => MAIL_FROM

  def new_motion(motion, referat, mail_to_finanz, mail_to_submitter)
    @greeting = []
    @greeting << "liebe Referent/innen von „#{referat.name}“" if referat
    @greeting << "liebes Finanzreferat" if mail_to_finanz
    @greeting = @greeting.join(", ").capitalize

    mail = []
    mail << MAIL_FINANZ if mail_to_finanz
    mail << referat.mail if referat

    @motion = motion

    add_motion_headers(motion)

    # send mails manually for each mail so that reply-to simply works
    ma = mail(:to => @motion.submitter, :subject => "Neuer Antrag (Kopie)", :reply_to => [mail, MAIL_FROM]).deliver if mail_to_submitter
    mb = mail(:to => mail, :subject => "Neuer Antrag", :reply_to => [@motion.submitter, MAIL_FROM]).deliver unless mail.empty?
    store_message_id(motion, [ma, mb])
  end

  def motion_denied(motion)
    mail = []
    mail << MAIL_FINANZ
    mail << motion.referat.mail if motion.referat

    add_motion_headers(motion)

    @motion = motion

    m = mail(:to => @motion.submitter, :subject => "Antrag abgelehnt", :reply_to => mail).deliver
    store_message_id(motion, m)
  end

  def motion_granted(motion)
    mail = []
    mail << MAIL_FINANZ
    mail << motion.referat.mail if motion.referat

    add_motion_headers(motion)

    @motion = motion

    m = mail(:to => @motion.submitter, :subject => "Antrag angenommen: Nächste Schritte", :reply_to => mail).deliver
    store_message_id(motion, m)
  end

  private
  # add header to be able to link this mail to a certain Motion
  # automatically
  def add_motion_headers(motion)
    headers["X-Antrag-ID"] = motion.id
    headers["X-Antrag-Status"] = motion.status
    headers["X-Antrag-Kind"] = motion.kind
    headers["References"] = motion.references unless motion.references.blank?
  end

  def store_message_id(motion, message)
    motion.references ||= ""
    [message].flatten.each { |m|  motion.references += " <#{m.message_id}>" unless motion.references.include?("<#{m.message_id}>") }
    motion.save
  end


end
