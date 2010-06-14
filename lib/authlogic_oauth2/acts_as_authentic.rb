module AuthlogicOauth2
  module ActsAsAuthentic
    def self.included(klass)
      klass.class_eval do
        extend Config
        add_acts_as_authentic_module(Methods, :prepend)
      end
    end

    module Config
      # The name of the oauth2 token field in the database.
      #
      # * <tt>Default:</tt> :oauth2_token
      # * <tt>Accepts:</tt> Symbol
      def oauth2_token_field(value = nil)
        rw_config(:oauth2_token_field, value, :oauth2_token)
      end
      alias_method :oauth2_token_field=, :oauth2_token_field
    end

    module Methods
      include Oauth2Process

      # Set up some simple validations
      def self.included(klass)
        klass.class_eval do
          alias_method "#{oauth2_token_field.to_s}=".to_sym, :oauth2_token=
        end

        return if !klass.column_names.include?(klass.oauth2_token_field.to_s)

        klass.class_eval do
          validate :validate_by_oauth2, :if => :authenticating_with_oauth2?

          validates_uniqueness_of klass.oauth2_token_field, :scope => validations_scope, :if => :using_oauth2?

          validates_length_of_password_field_options validates_length_of_password_field_options.merge(:if => :validate_password_with_oauth2?)
          validates_confirmation_of_password_field_options validates_confirmation_of_password_field_options.merge(:if => :validate_password_with_oauth2?)
          validates_length_of_password_confirmation_field_options validates_length_of_password_confirmation_field_options.merge(:if => :validate_password_with_oauth2?)
          validates_length_of_login_field_options validates_length_of_login_field_options.merge(:if => :validate_password_with_oauth2?)
          validates_format_of_login_field_options validates_format_of_login_field_options.merge(:if => :validate_password_with_oauth2?)
        end

        # email needs to be optional for oauth2
        klass.validate_email_field = false
      end

      def save(perform_validation = true, &block)
        if perform_validation && block_given? && redirecting_to_oauth2_server?
          # Save attributes so they aren't lost during the authentication with the oauth2 server
          session_class.controller.session[:authlogic_oauth2_attributes] = attributes.reject!{|k, v| v.blank?}
          redirect_to_oauth2
          return false
        end

        result = super
        yield(result) if block_given?
        result
      end

      # Accessors for oauth2 fields
      def oauth2_token
        read_attribute(oauth2_token_field)
      end
      
      def oauth2_token=(value)
        write_attribute(oauth2_token_field, value.blank? ? nil : value)
      end
      
      # Provides access to an API exposed on the access_token object
      def oauth2_access
        access_token
      end

    private

      def authenticating_with_oauth2?
        # Controller isn't available in all contexts (e.g. irb)
        return false unless session_class.controller
        
        # Initial request when user presses one of the button helpers
        (session_class.controller.params && !session_class.controller.params[:register_with_oauth2].blank?) ||
        # When the oauth2 provider responds and we made the initial request
        (oauth2_response && session_class.controller.session && session_class.controller.session[:oauth2_request_class] == self.class.name)
      end

      def authenticate_with_oauth2
        # Restore any attributes which were saved before redirecting to the oauth2 server
        self.attributes = session_class.controller.session.delete(:authlogic_oauth2_attributes)
        self.oauth2_token = generate_access_token.token
        
        # Execute callback if it's defined in the user model
        self.after_oauth2_authentication if self.respond_to?(:after_oauth2_authentication)
      end

      def access_token
        OAuth2::AccessToken.new(oauth2, read_attribute(oauth2_token_field))
      end

      def using_oauth2?
        respond_to?(oauth2_token_field) && !oauth2_token.blank?
      end

      def validate_password_with_oauth2?
        !using_oauth2? && require_password?
      end
      
      # Convenience methods for accessing configuration values
      def oauth2_token_field
        self.class.oauth2_token_field
      end
    end
  end
end