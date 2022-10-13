require_relative 'lib/fast/json/serializer/version'

Gem::Specification.new do |spec|
  spec.name          = "fast-json-serializer"
  spec.version       = Fast::Json::Serializer::VERSION
  spec.authors       = ["Santanu Karmakar"]
  spec.email         = ["skarmakar.personal@gmail.com"]

  spec.summary       = "Generate JSON bypassing ActiveRecord object building. Directly from PG result"
  spec.description   = "Generate JSON bypassing ActiveRecord object building. Directly from PG result"
  spec.homepage      = "https://github.com/skarmakar/fast-json-serializer"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'pg', '>= 1.1.1', '< 2.0'
  spec.add_dependency 'activerecord', '>= 5.0', '< 7.1'
end
