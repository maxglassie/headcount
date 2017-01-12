require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment'
require 'pry'

class EnrollmentTest < Minitest::Test

  def test_enrollment_creates_new_instance_with_empty_hash_argument
  enrollment = Enrollment.new(Hash.new)
  assert_equal Hash.new, enrollment.data
  end

  def test_enrollment_creates_new_instance_with_data
    enrollment = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    assert_equal ({2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}), enrollment.data[:kindergarten_participation]
  end

  def test_returns_timeframe_and_data_columns
    e = Enrollment.new({:name => "ACADEMY 20",
      :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal ({ 2010 => 0.391, 2011 => 0.353, 2012 => 0.267}),
                          e.kindergarten_participation_by_year
  end

  def test_returns_participation_in_year
    e = Enrollment.new({:name => "ACADEMY 20",
      :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal 0.391, e.kindergarten_participation_in_year(2010)
  end

  def test_add_data_to_hash
    e = Enrollment.new({:name => "ACADEMY 20",
      :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    e.add_data(:test, {"blazen" => 45})
    e.add_data(:jeezy, {"still_blazen" => 100})
    expected = {:name => "ACADEMY 20",
                        :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677},
                        :test => {"blazen" => 45},
                        :jeezy => {"still_blazen" => 100}}
    assert_equal expected, e.data
  end

  def test_graduation_rate_by_year
    e = Enrollment.new({
      :name => "ACADEMY 20",
      :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677},
      :high_school_graduation => {2010 => 0.895, 2011 => 0.895, 2012 => 0.889, 2013 => 0.913, 2014 => 0.898}
                                      })

    expected = {2010 => 0.895, 2011 => 0.895, 2012 => 0.889, 2013 => 0.913, 2014 => 0.898}
    assert_equal expected, e.graduation_rate_by_year
  end

  def test_graduation_rate_in_year
    e = Enrollment.new({
      :name => "ACADEMY 20",
      :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677},
      :high_school_graduation => {2010 => 0.895, 2011 => 0.895, 2012 => 0.889, 2013 => 0.913, 2014 => 0.898}
                                      })
    assert_equal 0.895, e.graduation_rate_in_year(2010)
  end

end #class end
