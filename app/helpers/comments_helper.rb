# encoding: utf-8

module CommentsHelper
  # Helper that adds the given text to the given motion. Intended for automatically generated
  # update/status comments. Comments will be put in italics. Stores the current user if
  # available, otherwise some other status information.
  def add_comment(motion, text)
    raise "May only add comments if user is currently logged in." unless current_user

    @comment = Comment.new({:comment => "*#{text}*"})
    @comment.ip = request.remote_ip
    @comment.user_id = current_user
    @comment.motion_id = motion
    flash[:warn] = "Kommentar konnte nicht gespeichert werden." unless @comment.save
  end
end
