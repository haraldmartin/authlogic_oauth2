require 'authlogic_oauth2'
require 'oauth2_callback_filter'

# Throw callback rack app into the middleware stack
ActionController::Dispatcher.middleware = ActionController::MiddlewareStack.new do |m|
  ActionController::Dispatcher.middleware.each do |klass|
    m.use klass
  end
  m.use Oauth2CallbackFilter
end