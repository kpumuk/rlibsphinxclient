module Sphinx
  begin
    require 'system_timer'
    Timeout = ::SystemTimer
  rescue LoadError
    require 'timeout'
    Timeout = ::Timeout
  end
end
