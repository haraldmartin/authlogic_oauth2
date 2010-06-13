module AuthlogicOauth2
  # This module is responsible for adding oauth2
  # to the Authlogic::Session::Base class.
  module Session
    def self.included(klass)
      klass.class_eval do
        extend Config
        include Methods
      end
    end

    module Config
      # * <tt>Default:</tt> :find_by_oauth2_token
      # * <tt>Accepts:</tt> Symbol
      def find_by_oauth2_method(value = nil)
        rw_config(:find_by_oauth2_method, value, :find_by_oauth2_token)
      end
      alias_method :find_by_oauth2_method=, :find_by_oauth2_method
    end

    module Methods
      include Oauth2Process

      def self.included(klass)
        klass.class_eval do
          validate :validate_by_oauth2, :if => :authenticating_with_oauth2?
        end
      end

      # Hooks into credentials so that you can pass a user who has already has an oauth2 access token.
      def credentials=(value)
        super
        values = value.is_a?(Array) ? value : [value]
        hash = values.first.is_a?(Hash) ? values.first.with_indifferent_access : nil
        self.record = hash[:priority_record] if !hash.nil? && hash.key?(:priority_record)
      end

      def record=(record)
        @record = record
      end

      # Clears out the block if we are authenticating with oauth2,
      # so that we can redirect without a DoubleRender error.
      def save(&block)
        block = nil if redirecting_to_oauth2_server?
        super(&block)
      end

    private

      def authenticating_with_oauth2?
        # Initial request when user presses one of the button helpers
        (controller.params && !controller.params[:login_with_oauth2].blank?) ||
        # When the oauth2 provider responds and we made the initial request
        (oauth2_response && controller.session && controller.session[:oauth2_request_class] == self.class.name)
      end

      def authenticate_with_oauth2
        if @record
          self.attempted_record = record
        else
          self.attempted_record = search_for_record(find_by_oauth2_method, generate_access_token.token)
        end

        if !attempted_record
          errors.add_to_base("Could not find user in our database, have you registered with your Oauth2 account?")
        end
      end

      def find_by_oauth2_method
        self.class.find_by_oauth2_method
      end
    end
  end
end