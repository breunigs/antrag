Rails.application.config.middleware.use OmniAuth::Strategies::LDAP,
      :title => "FSK Login",
      :host => '129.206.116.22',
      :port => 636,
      :method => :ssl,
      :base => 'dc=fsk,dc=uni-heidelberg,dc=de',
      :uid => 'uid',
      :name_proc => Proc.new { |n| n }
