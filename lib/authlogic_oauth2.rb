require File.dirname(__FILE__) + "/authlogic_oauth2/version"
require File.dirname(__FILE__) + "/authlogic_oauth2/oauth2_process"
require File.dirname(__FILE__) + "/authlogic_oauth2/acts_as_authentic"
require File.dirname(__FILE__) + "/authlogic_oauth2/session"
require File.dirname(__FILE__) + "/authlogic_oauth2/helper"
require File.dirname(__FILE__) + "/oauth2_callback_filter"

ActiveRecord::Base.send(:include, AuthlogicOauth2::ActsAsAuthentic)
Authlogic::Session::Base.send(:include, AuthlogicOauth2::Session)
ActionController::Base.helper AuthlogicOauth2::Helper

# Throw callback rack app into the middleware stack
if defined?(ActionController::Metal)
  Rails.configuration.middleware.use(Oauth2CallbackFilter) # Rails >= 3.0
else
  ActionController::Dispatcher.middleware.use(Oauth2CallbackFilter) # Rails < 3.0
end