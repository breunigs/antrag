class ApplicationController < ActionController::Base
  protect_from_forgery

  include UserHelper
  helper :all
end
