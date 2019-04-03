require 'minitest/autorun'
require 'therocktrading'

class TheRockTradingTest < Minitest::Test
  def test_get_fund
    assert_equal 9, TheRockTrading.get_fund('BTC', 'EUR')
  end
end
