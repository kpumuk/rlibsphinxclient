=begin rdoc
The generated SWIG module for accessing libsphinxclient's C API.

Includes the full set of libsphinxclient static methods (as defined in <tt>$INCLUDE_PATH/libsphinxclient.h</tt>), and classes for the available structs:

* <b>Rlibmemcached::MemcachedResultSt</b>
* <b>Rlibmemcached::MemcachedServerSt</b>
* <b>Rlibmemcached::MemcachedSt</b>
* <b>Rlibmemcached::MemcachedStatSt</b>
* <b>Rlibmemcached::MemcachedStringSt</b>

A number of SWIG typemaps and C helper methods are also defined in <tt>ext/rlibsphinxclient.i</tt>.

=end
module Rlibsphinxclient
end

require 'rlibsphinxclient'

module Sphinx
  Lib = Rlibsphinxclient
end

require 'sphinx/client'