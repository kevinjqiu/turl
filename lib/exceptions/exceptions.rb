module Turl
  class TurlException < StandardError
    attr_reader :message, :response_code

    def initialize(message, response_code)
      @message       = message
      @response_code = response_code
    end
  end

  class CannotVerifyOriginal < TurlException
    def initialize(original, original_response_code)
      super("Cannot verify original #{original}: code=#{original_response_code}", :unprocessable_entity)
    end
  end

  class CannotConnectOriginal < TurlException
    def initialize(original)
      super("Cannot connect original #{original}", :unprocessable_entity)
    end
  end

  class OriginalLinkTooLong < TurlException
    def initialize
      super("maximum 'original' value exceeded: #{Link::MAX_LENGTH}", :bad_request)
    end
  end

  class OriginalLinkEmpty < TurlException
    def initialize
      super("'original' value cannot be empty", :bad_request)
    end
  end

  class OriginalLinkSchemeInvalid < TurlException
    def initialize
      super("'original' can only start with http:// or https://", :bad_request)
    end
  end

  class OriginalLinkNotFound < TurlException
    def initialize(shortened)
      super("Original link not found the shortened link #{shortened}", :not_found)
    end
  end
end
