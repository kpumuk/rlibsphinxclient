require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('rlibsphinxclient') do |p|
  p.author = 'Dmytro Shteflyuk'
  p.email = 'kpumuk@kpumuk.info'
  p.summary = 'A Ruby wrapper for pure C searchd client API library'
  p.url = 'http://github.com/kpumuk/rlibsphinxclient'
  p.version = '0.1.0'
end

desc 'Update SWIG wrapper for pure C searchd client API library'
task :swig do
  system 'cd ext && swig -I/opt/local/include -I/opt/sphinx-0.9.9/include -ruby -autorename rlibsphinxclient.i'
end

task :t do
  system 'rake package'
  system 'cd pkg && env ARCHFLAGS="-arch i386" DEBUG=1 gem install rlibsphinxclient --no-rdoc --no-ri -- --with-libsphinxclient-dir=/opt/sphinx-0.9.9'
end
