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
      id = options[:id] || 'user_submit'
      if options[:type] == 'image'
        image_submit_tag(options[:src], :value => options[:value], :name => name, :id => id, :class => options[:class])
      else
        submit_tag(options[:value], :name => name, :id => id, :class => options[:class])
      end
    end
  end
end
