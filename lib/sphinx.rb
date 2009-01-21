=begin rdoc
The generated SWIG module for accessing libsphinxclient's C API.

Includes the full set of libsphinxclient static methods (as defined in <tt>$INCLUDE_PATH/libsphinxclient.h</tt>), and classes for the available structs.

A number of SWIG typemaps and C helper methods are also defined in <tt>ext/rlibsphinxclient.i</tt>.

=end
module Rlibsphinxclient
end

require 'rlibsphinxclient'

module Sphinx
end

require File.dirname(__FILE__) + '/sphinx/fast_client'
require File.dirname(__FILE__) + '/sphinx/request'
require File.dirname(__FILE__) + '/sphinx/response'
require File.dirname(__FILE__) + '/sphinx/client'
require File.dirname(__FILE__) + '/sphinx/timeout'
require File.dirname(__FILE__) + '/sphinx/safe_executor'
