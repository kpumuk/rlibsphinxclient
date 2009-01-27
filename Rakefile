require 'rubygems'
require 'rake'
require 'echoe'
require 'spec/rake/spectask'
require 'rake/rdoctask'

Echoe.new('rlibsphinxclient') do |p|
  p.author = 'Dmytro Shteflyuk'
  p.email = 'kpumuk@kpumuk.info'
  p.summary = 'A Ruby wrapper for pure C searchd client API library'
  p.url = 'http://github.com/kpumuk/rlibsphinxclient'
  p.version = '0.2.1'
  p.ignore_pattern = 'rdoc/**/*'
end

desc 'Update SWIG wrapper for pure C searchd client API library'
task :swig do
  system 'cd ext && swig -I/opt/local/include -I/opt/sphinx-0.9.9/include -ruby -autorename rlibsphinxclient.i'
end

desc 'Generate documentation for the rlibsphinxclient gem.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'rlibsphinxclient'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc', 'CHANGELOG.rdoc', 'LICENSE')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc 'Builds a gem and installs it to ~/.gem folder. Used only for development purposes.'
task :dev do
  system 'rake package'
  system 'cd pkg && env ARCHFLAGS="-arch i386" DEBUG=1 gem install rlibsphinxclient --no-rdoc --no-ri -- --with-libsphinxclient-dir=/opt/sphinx-0.9.9'
end
