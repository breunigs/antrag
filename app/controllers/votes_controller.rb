# encoding: utf-8

class VotesController < ApplicationController
  def new
    fs = Fachschaft.find(params[:fachschaft_id])
    return unless force_fachschaft(fs)

    motion = Motion.find(params[:motion_id])

    if motion.nil?
      flash[:error] = "Diesen Antrag gibt es nicht, Vote ungültig."
    elsif params[:result].blank?
      vote = Vote.find_by_motion_id_and_fachschaft_id(fs, motion)
      if vote
        add_comment(motion, "Abstimmungsergebnis entfernt (war vorher: #{vote.result_printable})")
        vote.destroy
        flash[:notice] = "Abstimmung von „#{motion.title}“ erfolgreich zurückgesetzt."
      end
    elsif !params[:result] =~ VOTE_REGEX
      flash[:error] = "Ungültige Antwortoption."
    else
      vote = Vote.find_or_create_by_motion_id_and_fachschaft_id(fs, motion)
      vote.result = params[:result]
      vote.save
      add_comment(motion, "Abgestimmt: #{vote.result_printable}")
      flash[:notice] = "Abstimmung von „#{motion.title}“ ist nun „#{vote.result_printable}“."
    end


    redirect_to((fs || "/")) and return
  end
end
