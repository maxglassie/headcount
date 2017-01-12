require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment_repository'
require './lib/enrollment'
require './lib/district_repository'
require './lib/statewide_test'
require './lib/statewide_test_repository'
require './lib/economic_profile'
require './lib/economic_profile_repository'

class EconomicProfileTest< Minitest::Test

  def test_economic_profile_creates_new_instance_with_empty_hash_argument
    economic_profile = EconomicProfile.new(Hash.new)
    assert_equal Hash.new, economic_profile.data
  end

  def test_economic_profile_creates_new_instance_with_data
    # skip
    economic_profile = EconomicProfile.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    assert_equal ({2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}), economic_profile.data[:kindergarten_participation]
  end

  def test_add_data_to_hash
    # skip
    ep = EconomicProfile.new({:name => "ACADEMY 20",
      :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    ep.add_data(:test, {"blazen" => 45})
    ep.add_data(:jeezy, {"still_blazen" => 100})
    expected = {:name => "ACADEMY 20",
                        :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677},
                        :test => {"blazen" => 45},
                        :jeezy => {"still_blazen" => 100}}
    assert_equal expected, ep.data
  end

end