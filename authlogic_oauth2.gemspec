# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{authlogic_oauth2}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andrew Hite"]
  s.date = %q{2010-06-13}
  s.description = %q{Authlogic OAuth is an extension of the Authlogic library to add OAuth support. OAuth can be used to allow users to login with their Twitter credentials.}
  s.email = %q{andrew@andrew-hite.com}
  s.extra_rdoc_files = ["README.rdoc", "lib/authlogic_oauth2.rb", "lib/authlogic_oauth2/acts_as_authentic.rb", "lib/authlogic_oauth2/helper.rb", "lib/authlogic_oauth2/oauth2_process.rb", "lib/authlogic_oauth2/session.rb", "lib/authlogic_oauth2/version.rb", "lib/oauth2_callback_filter.rb"]
  s.files = ["Manifest", "README.rdoc", "Rakefile", "authlogic_oauth2.gemspec", "init.rb", "lib/authlogic_oauth2.rb", "lib/authlogic_oauth2/acts_as_authentic.rb", "lib/authlogic_oauth2/helper.rb", "lib/authlogic_oauth2/oauth2_process.rb", "lib/authlogic_oauth2/session.rb", "lib/authlogic_oauth2/version.rb", "lib/oauth2_callback_filter.rb", "rails/init.rb"]
  s.homepage = %q{http://github.com/andyhite/authlogic_oauth2}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Authlogic_oauth2", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{authlogic_oauth2}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Authlogic OAuth is an extension of the Authlogic library to add OAuth support. OAuth can be used to allow users to login with their Twitter credentials.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<authlogic>, [">= 0"])
      s.add_runtime_dependency(%q<oauth2>, [">= 0"])
    else
      s.add_dependency(%q<authlogic>, [">= 0"])
      s.add_dependency(%q<oauth2>, [">= 0"])
    end
  else
    s.add_dependency(%q<authlogic>, [">= 0"])
    s.add_dependency(%q<oauth2>, [">= 0"])
  end
end
