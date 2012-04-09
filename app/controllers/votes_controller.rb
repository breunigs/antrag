# encoding: utf-8

class VotesController < ApplicationController
  def new
    #return if force_group("root")

    fs = Fachschaft.find(params[:fachschaft_id])
    motion = Motion.find(params[:motion_id])
    if fs.nil?
      flash[:error] = "Diese Fachschaft gibt es nicht, Vote ungültig."
      puts "wtf1"
    elsif motion.nil?
      flash[:error] = "Diesen Antrag gibt es nicht, Vote ungültig."
      puts "wtf2"
    elsif params[:result].blank?
      referat = Vote.find_by_motion_id_and_fachschaft_id(fs, motion)
      puts "wtf3"
      if referat
        referat.destroy
        flash[:notice] = "Abstimmung von „#{motion.title}“ erfolgreich zurückgesetzt."
      end
    elsif !params[:result] =~ VOTE_REGEX
      flash[:error] = "Ungültige Antwortoption."
      puts "wtf5"
    else
      vote = Vote.find_or_create_by_motion_id_and_fachschaft_id(fs, motion)
      vote.result = params[:result]
      vote.save
      flash[:notice] = "Abstimmung von „#{motion.title}“ ist nun „#{params[:result]}“."
      puts "wtf6"
    end


    redirect_to(fs || "/") and return
  end
end
