require 'minitest/autorun'
require 'minitest/pride'
require './lib/result_set'
require './lib/result_entry'
require './lib/district_repository'

class ResultEntryTest < Minitest::Test

  def test_result_entry
    re = ResultEntry.new
    assert re
  end

  def test_result_entry_takes_empty_hash_as_argument
    re = ResultEntry.new({})
    expected = (Hash.new)

    assert_equal expected, re.data
  end

  def test_result_entry_takes_hash_as_argument
    re = ResultEntry.new({
      free_and_reduced_price_lunch_rate: 0.5, 
      children_in_poverty_rate: 0.25, 
      high_school_graduation_rate: 0.75})

    assert_equal 0.5, re.data[:free_and_reduced_price_lunch_rate]
  end

  def test_retrieves_free_lunch
    re = ResultEntry.new({
      free_and_reduced_price_lunch_rate: 0.5, 
      children_in_poverty_rate: 0.25, 
      high_school_graduation_rate: 0.75})

    expected = 0.5
    result = re.free_and_reduced_price_lunch_rate

    assert_equal expected, result
  end

  def test_retrieves_children_in_poverty
    re = ResultEntry.new({
      free_and_reduced_price_lunch_rate: 0.5, 
      children_in_poverty_rate: 0.25, 
      high_school_graduation_rate: 0.75})

    expected = 0.25
    result = re.children_in_poverty_rate

    assert_equal expected, result
  end

  def test_retrieves_graduation_rate
    re = ResultEntry.new({
      free_and_reduced_price_lunch_rate: 0.5, 
      children_in_poverty_rate: 0.25, 
      high_school_graduation_rate: 0.75})

    expected = 0.75
    result = re.high_school_graduation_rate

    assert_equal expected, result
  end

end