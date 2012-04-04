# encoding: utf-8

class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]

    # TODO: Comment out when ready
    #~ logger.info "Login Data:"
    #~ logger.info PP.pp(auth, "")
#~
    #~ logger.info "Request.env:"
    #~ logger.info PP.pp(request.env, "")
#~
    #~ logger.info "params:"
    #~ logger.info PP.pp(params, "")


    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id

    redirect_to get_return_to_path, :notice => "Hallo #{auth["info"]["first_name"].capitalize}, der Login hat geklappt."
  end

  def destroy
    session[:user_id] = nil
    redirect_to "/", :notice => "Du bist jetzt ausgeloggt."
  end

  def failure
    msg = "Login fehlgeschlagen. " + case params[:message]
      when "invalid_credentials" then "Hast Du Dich evtl. bei Deinem Nutzernamen oder Passwort vertippt?"
      when "ldap_error"          then "Offenbar stimmt etwas mit dem LDAP-Server nicht. Bitte wende Dich an edv(at)fsk.uni-heidelberg.de."
      else                            "Der Fehler lautet: #{params[:message]}.  Bitte wende Dich an edv(at)fsk.uni-heidelberg.de."
    end

    path = "/login"
    path << "?return_to=#{Base64.urlsafe_encode64(get_return_to_path)}"

    redirect_to path, :notice => msg
  end

  def login
    if cookies["cookie_test"].blank?
      flash.now[:warning] = "Möglicherweise erlaubt Dein Browser keine Cookies. Wenn das der Fall ist, wirst Du Dich nicht richtig einloggen können."
    end
    # Try to set test cookie again, in case the user reloads the page to
    # see if it works now. Still needs to reload twice, but better than
    # nothing.
    set_test_cookie
  end

  private
  # Find path we should return the user to after a successful login.
  def get_return_to_path
    # see if it was stored as a parameter. This is the safest way to get
    # the correct URL.
    path = Base64.urlsafe_decode64(params[:return_to]) if params[:return_to]
    # If this data isn't available, try getting the referer instead.
    path ||= request.env['omniauth.origin'] || request.env["HTTP_REFERER"] || "/"
    # If we somehow end up on the login page, redirect to root to avoid
    # user confusion
    return "/" if path.include?("/login") || path.include?("/auth/")
    # return path
    path
  end
end
