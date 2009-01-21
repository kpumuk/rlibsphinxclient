module Sphinx
  class SafeExecutor
    def self.execute(timeout = 5, attempts = 3, &block)
      Sphinx::Timeout.timeout(timeout, &block)
    rescue ::Timeout::Error
      attempts -= 1
      raise if attempts <= 0
      retry
    end
  end
end
