# encoding: utf-8

module CommentsHelper
  def add_comment(motion, text)
    raise "May only add comments if user is currently logged in." unless current_user

    @comment = Comment.new({:user_id => current_user, :motion_id => motion, :comment => text})
    flash[:warn] = "Kommentar konnte nicht gespeichert werden." unless @comment.save
  end
end
