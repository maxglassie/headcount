require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment_repository'
require './lib/enrollment'
require './lib/district_repository'
require './lib/statewide_test'
require './lib/statewide_test_repository'

class StatewideTestTest< Minitest::Test

  def test_statewide_creates_new_instance_with_empty_hash_argument
    statewide = StatewideTest.new(Hash.new)
    assert_equal Hash.new, statewide.data
  end

  def test_statewide_creates_new_instance_with_data
    statewide = StatewideTest.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    assert_equal ({2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}), statewide.data[:kindergarten_participation]
  end

  def test_add_data_to_hash
    e = StatewideTest.new({:name => "ACADEMY 20",
      :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    e.add_data(:test, {"blazen" => 45})
    e.add_data(:jeezy, {"still_blazen" => 100})
    expected = {:name => "ACADEMY 20",
                        :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677},
                        :test => {"blazen" => 45},
                        :jeezy => {"still_blazen" => 100}}
    assert_equal expected, e.data
  end

end