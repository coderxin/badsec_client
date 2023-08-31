# frozen_string_literal: true

require_relative 'lib/badsec_client/version'

Gem::Specification.new do |spec|
  spec.name = 'badsec_client'
  spec.version = BadsecClient::VERSION
  spec.authors = ['Andrejs Eisaks']
  spec.email = ['eisaks.andrejs@gmail.com']

  spec.summary = 'Retrieves the user ID list from the BADSEC server and outputs it in JSON format.'
  spec.description = 'Retrieves the user ID list from the BADSEC server and outputs it in JSON format.'
  spec.homepage = 'https://github.com/coderxin/badsec_client'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/coderxin/badsec_client'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 2.7'
end
