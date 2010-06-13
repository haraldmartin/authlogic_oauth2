require 'rubygems'  
require 'rake'  
require 'echoe'
require File.dirname(__FILE__) + "/lib/authlogic_oauth2/version"
  
Echoe.new('authlogic_oauth2', AuthlogicOauth2::Version::STRING) do |p|  
  p.description     = "Authlogic OAuth is an extension of the Authlogic library to add OAuth support. OAuth can be used to allow users to login with their Twitter credentials."  
  p.url             = "http://github.com/andyhite/authlogic_oauth2"  
  p.author          = "Andrew Hite"  
  p.email           = "andrew@andrew-hite.com"
  p.runtime_dependencies = ['authlogic', 'oauth2']
end  
  
Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }