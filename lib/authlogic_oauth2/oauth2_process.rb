module AuthlogicOauth2
  module Oauth2Process

  private

    def validate_by_oauth2
      validate_email_field = false

      if oauth2_response.blank?
        redirect_to_oauth2
      else
        authenticate_with_oauth2
      end
    end

    def redirecting_to_oauth2_server?
      authenticating_with_oauth2? && oauth2_response.blank?
    end

    def redirect_to_oauth2
      authorize_url = oauth2.web_server.authorize_url(:redirect_uri => build_callback_url, :scope => oauth2_scope)

      # Store the class which is redirecting, so we can ensure other classes
      # don't get confused and attempt to use the response
      oauth2_controller.session[:oauth2_request_class] = self.class.name

      # Tell our rack callback filter what method the current request is using
      oauth2_controller.session[:oauth2_callback_method] = oauth2_controller.request.method

      oauth2_controller.redirect_to authorize_url
    end

    def build_callback_url
      oauth2_controller.url_for :controller => oauth2_controller.controller_name, :action => oauth2_controller.action_name
    end

    def generate_access_token
      oauth2.web_server.get_access_token(oauth2_controller.params[:code], :redirect_uri => build_callback_url)
    end

    def oauth2_response
      oauth2_controller.params && oauth2_controller.params[:code]
    end

    def oauth2_controller
      is_auth_session? ? controller : session_class.controller
    end

    def oauth2
      is_auth_session? ? self.class.oauth2_client : session_class.oauth2_client
    end
    
    def oauth2_scope
      is_auth_session? ? self.class.oauth2_scope : session_class.oauth2_scope
    rescue NoMethodError
      nil
    end

    def is_auth_session?
      self.is_a?(Authlogic::Session::Base)
    end

  end
end