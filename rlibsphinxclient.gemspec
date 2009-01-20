# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rlibsphinxclient}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dmytro Shteflyuk"]
  s.date = %q{2009-01-20}
  s.description = %q{A Ruby wrapper for pure C searchd client API library}
  s.email = %q{kpumuk@kpumuk.info}
  s.files = ["README.rdoc", "VERSION.yml", "lib/sphinx", "lib/sphinx/fast_client.rb", "lib/sphinx.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/kpumuk/rlibsphinxclient}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A Ruby wrapper for pure C searchd client API library}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
