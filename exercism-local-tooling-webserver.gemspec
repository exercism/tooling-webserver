require_relative 'lib/exercism_local_tooling_webserver/version'

Gem::Specification.new do |spec|
  spec.name          = "exercism-local-tooling-webserver"
  spec.version       = Exercism::Local::Tooling::Webserver::VERSION
  spec.authors       = ["Erik Schierboom"]
  spec.email         = ["erik_schierboom@hotmail.com"]

  spec.summary       = %q{A local webserver for Exercism tooling}
  spec.homepage      = "https://exercism.io"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  
  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = ["exercism_local_tooling_webserver"]
  spec.require_paths = ["lib"]

  spec.add_dependency "json"
  spec.add_dependency "sinatra"
  spec.add_dependency "sinatra-contrib"
  spec.add_dependency "puma"
  spec.add_dependency "etc"

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "mocha"
end
