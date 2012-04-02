class SessionsController < ApplicationController
  def create
    begin
      auth = request.env["omniauth.auth"]
    rescue Exception => e
      logger.error "OmniAuth Error"
      logger.error e.to_s
      logger.error e.backtrace.join("\n")
    end

    # TODO: Comment out when ready
    #logger.info "Login Data:"
    #logger.info PP.pp(auth, "")


    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id

    # Find path to redirect user to. If no return_to parameter was given
    # try to redirect to HTTP_REFERER (available via omniauth.origin)
    if request.env['omniauth.params']["return_to"]
      path = Base64.decode64(request.env['omniauth.params']["return_to"])
    end
    path ||= request.env['omniauth.origin'] || "/"

    redirect_to path, :notice => "Hallo #{auth["info"]["first_name"].capitalize}, der Login hat geklappt."
  end

  def destroy
    session[:user_id] = nil
    redirect_to "/", :notice => "Du bist jetzt ausgeloggt."
  end
end
