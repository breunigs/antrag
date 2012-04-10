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

  # returns true if the current user is in the given Fachschaft. Expects
  # fachschaft to be either the Model or its ID. Set root to false if
  # the root user is not qualified.
  def is_current_in_fs?(fachschaft, root = true)
    return false unless current_user
    return true if root && is_current_root?
    fachschaft = Fachschaft.find(fachschaft) if fachschaft.is_a? Integer
    fachschaft.users.include?(current_user)
  end

  # returns true if the current user is in the given group(s). Accepts
  # an array or a string/symbol.
  def is_current_in_group?(groups)
    return false unless current_user
    groups = [groups] if groups.is_a? String
    groups.flatten!
    groups.map! { |g| g.to_s }
    raise unless groups.is_a? Array

    !((current_user.groups || "").split(" ") & groups).empty?
  end

  # checks if a user is currently logged in and redirects to the login
  # prompt if he isn't. Use it like this:
  #   return unless force_login
  # This will stop the execution further down if a login is required.
  # You can also make this a before_filter.
  # The user is redirected back to the currently shown page after a
  # successful login.
  def force_login
    return true if current_user
    path = Base64.urlsafe_encode64(request.fullpath)
    redirect_to "/login?return_to=#{path}"
    return false
  end

  # checks if the current user is in at least one of the groups given.
  # May call force_login automatically. Returns false if the user has
  # insufficient rights; true if it’s ok to proceed. Use it like this:
  #  return unless force_group("root")
  #  return unless force_group([:root, "asdf"])
  def force_group(groups)
    # require login
    return false unless force_login
    # Login ok but no current user?
    raise unless current_user

    # If the intersection of the groups is empty, the user doesn’t have
    # enough rights. Return true in that case.
    ok = is_current_in_group?(groups)
    if not ok
      flash[:error] = "Du hast nicht genügend Rechte für diesen Vorgang."
      redirect_to (request.referer || "/")
    end
    return ok
  end

  # Ensures the user is a member of the given Fachschaft or root, unless
  # you explicitly turn that off. Use it as parameterized_before_filter
  # or like this:
  #  return unless force_fachschaft(«Fachschaft»)
  # Note that fachschaft may be the class or the id. If it is not found
  # the access is automatically denied.
  def force_fachschaft(fs, root_ok = true)
    return false unless force_login
    return true if root_ok && is_current_root?
    fs = Fachschaft.find(fs) if fs.is_a? Integer
    unless fs
      flash[:error] = "Diese Fachschaft existiert gar nicht."
      redirect_to (request.referer || "/")
      return false
    end
    if fs.users.include?(current_user)
      return true
    else
      flash[:error] = "Du bist nicht in der Fachschaft und kannst daher auch nicht für sie abstimmen."
      redirect_to (request.referer || "/")
      return false
    end
  end

  private

  def set_test_cookie
    cookies["cookie_test"] = "I am not paranoid."
  end
end
