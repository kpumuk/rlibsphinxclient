require 'mkmf'

if ENV['SWIG']
  puts "running SWIG"
  $stdout.write `swig -I/opt/local/include -I/opt/sphinx-0.9.9/include -ruby -autorename rlibsphinxclient.i`
end

$CFLAGS.gsub! /-O\d/, ''

if ENV['DEBUG']
  puts "setting debug flags"
  $CFLAGS << " -O0 -ggdb -DHAVE_DEBUG"
else
  $CFLAGS << " -O3"
end

find_library(*['sphinxclient', 'sphinx_create', dir_config('libsphinxclient').last].compact) or
  raise "shared library 'libsphinxclient' not found"

find_header(*['sphinxclient.h', dir_config('libsphinxclient').first].compact) or
  raise "header file 'sphinxclient.h' not found"

create_makefile 'rlibsphinxclient'
