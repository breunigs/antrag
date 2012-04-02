class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user


  private

  # returns the currently logged in user, or nil, if no one is logged in
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  # checks if a user is currently logged in and redirects to the login
  # prompt if he isn't. Use it like this:
  #   return if force_login
  # This will stop the execution further down if a login is required.
  # The user is redirected back to the currently shown page after a
  # successful login.
  def force_login
    return false if current_user
    path = Base64.urlsafe_encode64(request.fullpath)
    redirect_to "/login?return_to=#{path}"
    return true
  end
end
