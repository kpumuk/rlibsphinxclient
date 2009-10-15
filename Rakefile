require 'rubygems'
require 'rake'
require 'spec/rake/spectask'
require 'rake/rdoctask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name           = 'rlibsphinxclient'
    gemspec.summary        = 'A Ruby wrapper for pure C searchd client API library.'
    gemspec.email          = 'kpumuk@kpumuk.info'
    gemspec.homepage       = 'http://github.com/kpumuk/rlibsphinxclient'
    gemspec.author         = 'Dmytro Shteflyuk'
    gemspec.extensions     = ['ext/extconf.rb']
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts 'Jeweler not available. Install it with: sudo gem install jeweler -s http://gemcutter.org'
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
