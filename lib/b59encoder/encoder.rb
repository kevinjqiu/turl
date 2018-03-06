module Turl
  module UrlSafeBase59Encoder
    # The allowed alphabet of this encoding scheme
    # The alphabet is essentially URL-safe base64
    # minus ambiguous letters (o, O, i, I, l)
    ALPHABET = (Array('0'..'9') + Array('a'..'z') + Array('A'..'Z') + ['-', '_'] - %w[o O i I l]).freeze

    def b59encode(num)
      return ALPHABET[num] if num < 9
      digits = []
      while num > 0
        remainder = num % ALPHABET.length
        digits << ALPHABET[remainder]
        num /= ALPHABET.length
      end
      digits.reverse.join
    end

    def b59decode(str)
      (str.reverse.split('').zip(0..str.length).collect do |digit, position|
        ord = ALPHABET.find_index digit
        ord * ALPHABET.length**position
      end).sum
    end
  end
end
