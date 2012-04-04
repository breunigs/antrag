class ApplicationController < ActionController::Base
  protect_from_forgery

  include UserHelper
  helper :all
  before_filter :set_test_cookie, :except => :login
end
