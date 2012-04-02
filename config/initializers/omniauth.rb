Rails.application.config.middleware.use OmniAuth::Strategies::LDAP,
      :title => "FSK Login",
      :host => '129.206.116.22',
      :port => 636,
      :method => :ssl,
      :base => 'dc=fsk,dc=uni-heidelberg,dc=de',
      :uid => 'uid',
      :name_proc => Proc.new { |n| n }

# Be more verbose about login failures.
# http://inside.oib.com/development/getting-more-information-from-omniauth-exceptions/
OmniAuth.config.on_failure do |env|
  exception = env['omniauth.error']
  error_type = env['omniauth.error.type']
  strategy = env['omniauth.error.strategy']

  Rails.logger.error("OmniAuth Error (#{error_type}): #{exception.inspect}")

  # try to get source url
  path = env["rack.request.form_hash"]["return_to"] if env["rack.request.form_hash"]
  path ||= Base64.urlsafe_encode64(env['omniauth.origin'] || env["HTTP_REFERER"] || "/")

  new_path = "#{env['SCRIPT_NAME']}#{OmniAuth.config.path_prefix}/failure?message=#{error_type}&strategy=#{strategy.name}&return_to=#{path}"

  [302, {'Location' => new_path, 'Content-Type'=> 'text/html'}, []]
end

