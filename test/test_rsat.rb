require 'minitest/autorun'
require 'rsat'

class TestRSAT < Minitest::Test
  def test_sanity
    s = RSAT.new
    s.parse_and_add_clause "A B ~C"
    assert_equal %w{ A B C }, s.variables
    assert_equal({"A" => 0, "B" => 1, "C" => 2 }, s.variable_table)
    assert_equal([[0, 2, 5]], s.clauses)
    assert_equal "A B ~C", s.to_s
  end
end
