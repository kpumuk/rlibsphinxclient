require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = 'rlibsphinxclient'
    s.summary = 'A Ruby wrapper for pure C searchd client API library'
    s.email = 'kpumuk@kpumuk.info'
    s.homepage = 'http://github.com/kpumuk/rlibsphinxclient'
    s.description = 'A Ruby wrapper for pure C searchd client API library'
    s.authors = [ 'Dmytro Shteflyuk' ]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

task :t do
  system 'rake package'
  system 'cd pkg && env ARCHFLAGS="-arch i386" DEBUG=1 gem install sphinx --no-rdoc --no-ri -- --with-libsphinxclient-dir=/opt/sphinx-0.9.9'
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }