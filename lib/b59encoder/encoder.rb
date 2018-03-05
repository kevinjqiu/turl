module Turl
  module UrlSafeBase59Encoder
    # The allowed alphabet of this encoding scheme
    # The alphabet is essentially URL-safe base64
    # minus ambiguous letters (o, O, i, I, l)
    ALPHABET = (Array("0".."9") + Array("a".."z") + Array("A".."Z") + ["-", "_"] - ["o", "O", "i", "I", "l"]).freeze

    def b59encode(n)
      return ALPHABET[n] if n < 9
      digits = []
      while n > 0
        remainder = n % ALPHABET.length
        digits << ALPHABET[remainder]
        n = n / ALPHABET.length
      end
      digits.reverse.join
    end
  end
end
