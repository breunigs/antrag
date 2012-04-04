# encoding: utf-8

module UserHelper
  # returns the currently logged in user, or nil, if no one is logged in
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  # returns true if the current user is root
  def is_current_root?
    User.is_root?(current_user)
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

  # checks if the current user is in at least one of the groups given.
  # May call force_login automatically. Returns true if the user has
  # insufficient rights; false if it’s ok to proceed. Use it like this:
  #  return if force_group("root")
  #  return if force_group([:root, "asdf"])
  def force_group(groups)
    groups = [groups] if groups.is_a? String
    groups.map! { |g| g.to_s }
    raise unless groups.is_a? Array
    # require login
    return if force_login
    # Login ok but no current user?
    raise unless current_user

    # If the intersection of the groups is empty, the user doesn’t have
    # enough rights. Return true in that case.
    denied = ((current_user.groups || "").split(" ") & groups).empty?
    if denied
      flash[:error] = "Du hast nicht genügend Rechte für diesen Vorgang."
      redirect_to (request.referer || "/")
    end
    return denied
  end

  private

  def set_test_cookie
    cookies["cookie_test"] = "I am not paranoid."
  end
end
