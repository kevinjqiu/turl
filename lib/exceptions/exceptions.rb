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

  class OriginalLinkTooLong < StandardError
    attr_reader :message

    def initialize
      @message = "maximum 'original' value exceeded: #{Link::MAX_LENGTH}"
    end
  end

  class OriginalLinkEmpty < StandardError
    attr_reader :message

    def initialize
      @message = "'original' value cannot be empty"
    end
  end
end
