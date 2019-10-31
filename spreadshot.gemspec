lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "spreadshot/version"

Gem::Specification.new do |spec|
  spec.name          = "spreadshot"
  spec.version       = Spreadshot::VERSION
  spec.authors       = ["George Osae"]
  spec.email         = ["coderwasp@gmail.com"]

  spec.summary       = %q{Library for reading spreadsheets with support for multiple backends}
  spec.homepage      = "https://github.com/gkosae/spreadshot.git"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/gkosae/spreadshot.git"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "smarter_csv", "~> 1.2.6"
  spec.add_dependency "rubyXL", "~> 3.3.33"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "byebug", "~> 11.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
