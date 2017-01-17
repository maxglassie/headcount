require 'minitest/autorun'
require 'minitest/pride'
require './lib/result_set'
require './lib/result_entry'
require './lib/district_repository'

class ResultSetTest < Minitest::Test

  def test_result_set
    rs = ResultSet.new
    assert rs
  end

  def test_result_set_has_matching_districts_and_statewide_average
    r1 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.5,
    children_in_poverty_rate: 0.25,
    high_school_graduation_rate: 0.75})

    r2 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.3,
    children_in_poverty_rate: 0.2,
    high_school_graduation_rate: 0.6})

    rs = ResultSet.new(matching_districts: [r1], statewide_average: r2)

    expected_1 = r1
    result_1 = rs.matching_districts.first

    expected_2 = r2
    result_2 = rs.statewide_average

    assert_equal expected_1, result_1
    assert_equal expected_2, result_2
  end

  def test_matching_districts_methods
    r1 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.5,
    children_in_poverty_rate: 0.25,
    high_school_graduation_rate: 0.75})

    r2 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.3,
    children_in_poverty_rate: 0.2,
    high_school_graduation_rate: 0.6})

    rs = ResultSet.new(matching_districts: [r1], statewide_average: r2)

    expected_free = 0.5
    expected_child_poverty = 0.25
    expected_graduation = 0.75

    result_free = rs.matching_districts.first.free_and_reduced_price_lunch_rate
    result_child_poverty = rs.matching_districts.first.children_in_poverty_rate
    result_graduation = rs.matching_districts.first.high_school_graduation_rate

    assert_equal expected_free, result_free
    assert_equal expected_child_poverty, result_child_poverty
    assert_equal expected_graduation, result_graduation
  end

  def test_statewide_average_methods
    r1 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.5,
    children_in_poverty_rate: 0.25,
    high_school_graduation_rate: 0.75})

    r2 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.3,
    children_in_poverty_rate: 0.2,
    high_school_graduation_rate: 0.6})

    rs = ResultSet.new(matching_districts: [r1], statewide_average: r2)

    expected_free = 0.3
    expected_child_poverty = 0.2
    expected_graduation = 0.6

    result_free = rs.statewide_average.free_and_reduced_price_lunch_rate
    result_child_poverty = rs.statewide_average.children_in_poverty_rate
    result_graduation = rs.statewide_average.high_school_graduation_rate

    assert_equal expected_free, result_free
    assert_equal expected_child_poverty, result_child_poverty
    assert_equal expected_graduation, result_graduation
  end

end