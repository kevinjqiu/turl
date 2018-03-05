require 'tokenizer/tokenizer.rb'

class TokenizerTest < ActiveSupport::TestCase
  include Turl::Tokenizer

  test "0 is encoded to 0" do
    assert_equal "0", b59encode(0)
  end

  test "9 is encoded to 9" do
    assert_equal "9", b59encode(9)
  end

  test "58 is encoded to _" do
    assert_equal "_", b59encode(58)
  end

  test "59 is encoded to 10" do
    assert_equal "10", b59encode(59)
  end
end
