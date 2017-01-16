require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment_repository'
require './lib/enrollment'
require './lib/district_repository'
require './lib/statewide_test'
require './lib/statewide_test_repository'
require './lib/economic_profile'
require './lib/economic_profile_repository'

class EconomicProfileRepositoryTest < Minitest::Test

  def setup
    @epr = EconomicProfileRepository.new
    @dr = DistrictRepository.new

    @fixture_hash = {
                      :economic_profile => {
                          :median_household_income => "./test/fixtures/median_household_fixture.csv",
                          :children_in_poverty => "./test/fixtures/children_in_poverty_fixture.csv",
                          :free_or_reduced_price_lunch => "./test/fixtures/free_or_reduced_price_lunch_fixture.csv",
                          :title_i => "./test/fixtures/title_i_fixture.csv"
                                                        }
                                }

    @economic_profile_full_hash = {
                              :economic_profile => {
                                  #requires new logic
                                  :median_household_income => "./data/Median household income.csv",
                                  #same logic as enrollment
                                  :children_in_poverty => "./data/School-aged children in poverty.csv",
                                  #
                                  :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                                  :title_i => "./data/Title I students.csv"
                                                                }
                                }

      @full_data_hash = {
        :enrollment => {
                      :kindergarten => "./data/Kindergartners in full-day program.csv",
                      :high_school_graduation => "./data/High school graduation rates.csv",
                     },
         :statewide_testing => {
                       :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                       :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                       :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                       :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                       :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                     },
         :economic_profile => {
                      :median_household_income => "./data/Median household income.csv",
                      :children_in_poverty => "./data/School-aged children in poverty.csv",
                      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                      :title_i => "./data/Title I students.csv"
                    }
                                        }
  end

  def test_economic_profile_repo_exists
      assert_equal EconomicProfileRepository, @epr.class
  end

  def test_create_open_file_hash
    output = @epr.create_open_file_hash(@fixture_hash[:economic_profile])

    assert output[:median_household_income]
  end

  def test_median_household_create_data_hash
    median_household_open_file = @epr.open_file(@fixture_hash[:economic_profile][:median_household_income])
    result = @epr.median_household_create_data_hash(median_household_open_file)
    expected = {
                      [2005, 2009]=>56222, 
                      [2006, 2010]=>56456, 
                      [2008, 2012]=>58244, 
                      [2007, 2011]=>57685, 
                      [2009, 2013]=>58433
                      }

    assert_equal expected, result["COLORADO"]
  end

   def test_children_in_poverty_create_data_hash
    child_poverty_open_file = @epr.open_file(@fixture_hash[:economic_profile][:children_in_poverty])
    result = @epr.children_in_poverty_create_data_hash(child_poverty_open_file)
    expected = {1995=>0.032, 1997=>0.035, 
                        1999=>0.032, 2000=>0.031, 
                        2001=>0.029, 2002=>0.033, 
                        2003=>0.037, 2004=>0.034, 
                        2005=>0.042, 2006=>0.036, 
                        2007=>0.039, 2008=>0.04404, 
                        2009=>0.047, 2010=>0.05754, 
                        2011=>0.059, 2012=>0.064, 
                        2013=>0.048}

    assert_equal expected, result["ACADEMY 20"]
  end

  def test_free_or_reduced_price_lunch_create_data_hash
    free_lunch_open_file = @epr.open_file(@fixture_hash[:economic_profile][:free_or_reduced_price_lunch])
    result = @epr.free_or_reduced_price_lunch_create_data_hash(free_lunch_open_file)
    expected = {2000=>{:percentage=>0.27, :total=>195149}, 
                        2001=>{:total=>204299, :percentage=>0.27528}, 
                        2002=>{:percentage=>0.28509, :total=>214349}, 
                        2003=>{:total=>228710, :percentage=>0.3}, 
                        2004=>{:percentage=>0.3152, :total=>241619}, 
                        2005=>{:total=>259673, :percentage=>0.3326}, 
                        2006=>{:percentage=>0.337, :total=>267590}, 
                        2007=>{:total=>275560}
                      }

    assert_equal expected, result["COLORADO"]
  end

  def test_title_i_create_data_hash
    title_i_open_file = @epr.open_file(@fixture_hash[:economic_profile][:title_i])
    result = @epr.title_i_create_data_hash(title_i_open_file)
    expected = {2009=>0.216, 2011=>0.224, 
                        2012=>0.22907, 2013=>0.23178, 
                        2014=>0.23556}

    assert_equal expected, result["COLORADO"]
  end

  def test_create_data_hash_dispatcher
    output = @epr.create_open_file_hash(@fixture_hash[:economic_profile])
    result = @epr.create_data_hash_dispatcher(output)

    expected_household = 58244
    expected_child_poverty = 0.029
    expected_free_lunch = 228710
    expected_title_i = 0.178

    assert_equal expected_household, result[:median_household_income]["COLORADO"][[2008, 2012]]
    assert_equal expected_child_poverty, result[:children_in_poverty]["ACADEMY 20"][2001]
    assert_equal expected_free_lunch, result[:free_or_reduced_price_lunch]["COLORADO"][2003][:total]
    assert_equal expected_title_i, result[:title_i]["AGATE 300"][2009]
  end

  def test_populate_repository
    output = @epr.create_open_file_hash(@fixture_hash[:economic_profile])
    data_hash = @epr.create_data_hash_dispatcher(output)
    @epr.populate_repository(data_hash[:median_household_income])

    result = @epr.find_by_name("Colorado")

    expected = EconomicProfile

    assert_equal expected, result.class
  end

  def test_add_data_to_repository_objects
    output = @epr.create_open_file_hash(@fixture_hash[:economic_profile])
    data_hash = @epr.create_data_hash_dispatcher(output)
    @epr.populate_repository(data_hash[:median_household_income])

    @epr.add_data_to_repository_objects(:median_household_income, data_hash[:median_household_income])

    economic_profile = @epr.find_by_name("COLORADO")
    result = economic_profile.data[:median_household_income]
    expected = {[2005, 2009]=>56222, 
                        [2006, 2010]=>56456, 
                        [2008, 2012]=>58244, 
                        [2007, 2011]=>57685, 
                        [2009, 2013]=>58433
                      }

    assert_equal expected, result
  end

  def test_load_data_with_fixtures
    @epr.load_data(@fixture_hash)

    expected = 228710

    ep = @epr.find_by_name("COLORADO")
    assert_equal expected, ep.data[:free_or_reduced_price_lunch][2003][:total]
  end

  def test_load_district_repository
    @dr.load_data(@full_data_hash)
    district = @dr.find_by_name("ADAMS COUNTY 14")

    economic_profile = district.economic_profile

    assert_equal EconomicProfile, economic_profile.class
  end

end