require 'minitest/autorun'
require_relative '../utils'

class TestUtils < Minitest::Test
  def test_generate_deposit_address
    deposit_address = generate_deposit_address
    assert_kind_of(String, deposit_address)
    assert_equal(8, deposit_address.length)
  end
end
