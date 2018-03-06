require 'test_helper'

class LinkTest < ActiveSupport::TestCase

  test 'original cannot exceed maximum length constraint' do
    original = 'a' * 2085
    assert_raises ActiveRecord::ValueTooLong do
      Link.create({
        original: original
      })
    end
  end
end
