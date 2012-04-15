# encoding: utf-8

module CommentsHelper
  # Helper that adds the given text to the given motion. Intended for automatically generated
  # update/status comments. Comments will be put in italics. Stores the current user if
  # available, otherwise some other status information.
  def add_comment(motion, text)
    @comment = Comment.new({:comment => "*#{text.gsub("\n\n", "*\n\n*")}*"})
    @comment.ip = request.remote_ip
    @comment.user_id = current_user
    @comment.motion_id = motion
    flash[:warn] = "Kommentar konnte nicht gespeichert werden." unless @comment.save
  end
end
