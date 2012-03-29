class SessionsController < ApplicationController
  def create
    begin
      auth = request.env["omniauth.auth"]
    rescue Exception => e
      logger.error "OmniAuth Error"
      logger.error e.to_s
      logger.error e.backtrace.join("\n")
    end
    logger.info "Login Data:"
    logger.info PP.pp(auth, "")
            
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to "/auth/lework", :notice => "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to "/", :notice => "Signed out!"
  end
end
