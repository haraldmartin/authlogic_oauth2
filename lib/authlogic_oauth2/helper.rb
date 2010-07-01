module AuthlogicOauth2
  module Helper
    def oauth2_register_button(options = {})
      oauth2_button('register_with_oauth2', options)
    end
    
    def oauth2_login_button(options = {})
      oauth2_button('login_with_oauth2', options)
    end
  
  private
    def oauth2_button(name, options = {})
      submit_tag(options[:value], :name => name, :id => 'user_submit', :class => options[:class])
    end
  end
end