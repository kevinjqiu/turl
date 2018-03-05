module Turl
  class CannotVerifyOriginal < StandardError
    attr_reader :original, :response_code
    def initialize(original, response_code)
      @original = original
      @response_code = response_code
    end
  end

  class CannotConnectOriginal < StandardError
    attr_reader :original
    def initialize(original)
      @original = original
    end
  end
end
