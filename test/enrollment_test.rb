require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment_repository'
require './lib/enrollment'
require 'pry'

class EnrollmentTest < Minitest::Test

  def test_returns_timeframe_and_data_columns
    # skip
    e = Enrollment.new({:name => "ACADEMY 20",
      :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal ({ 2010 => 0.391, 2011 => 0.353, 2012 => 0.267}),
                  e.kindergarten_participation_by_year
  end

  def test_returns_participation_in_year
    # skip
    e = Enrollment.new({:name => "ACADEMY 20",
      :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal 0.391, e.kindergarten_participation_in_year(2010)
  end

end
