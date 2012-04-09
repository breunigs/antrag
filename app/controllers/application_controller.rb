class ApplicationController < ActionController::Base
  protect_from_forgery

  include UserHelper
  include CommentsHelper
  helper :all
  before_filter :set_test_cookie, :except => :login

  # via http://blog.aclarke.eu/passing-a-parameter-to-a-before-filter/
  def self.parameterized_before_filter(filter_name, *args)
    options = args.extract_options!

    self.before_filter(options) { |controller| controller.send(filter_name, *args) }
  end
end
