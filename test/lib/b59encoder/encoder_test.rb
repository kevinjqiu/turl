require 'b59encoder/encoder.rb'

class TokenizerTest < ActiveSupport::TestCase
  include Turl::UrlSafeBase59Encoder

  test "0 is encoded to 0" do
    assert_equal "0", b59encode(0)
  end

  test "9 is encoded to 9" do
    skip
    assert_equal "9", b59encode(9)
  end

  test "58 is encoded to _" do
    skip
    assert_equal "_", b59encode(58)
  end

  test "59 is encoded to 10" do
    skip
    assert_equal "10", b59encode(59)
  end

  test "roundtrip" do
    for i in 0..1000000 do
      assert_equal i, b59decode(b59encode(i))
    end
  end
end
