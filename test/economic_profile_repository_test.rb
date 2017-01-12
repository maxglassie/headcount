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
    @fixture_hash = {
                      :economic_profile => {
                          :median_household_income => "./data/Median household income.csv",
                          :children_in_poverty => "./data/School-aged children in poverty.csv",
                          :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                          :title_i => "./data/Title I students.csv"
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

      # @dr = DistrictRepository.new
      # @dr.load_data({:enrollment => {
      #                 :kindergarten => "./data/Kindergartners in full-day program.csv",
      #                 :high_school_graduation => "./data/High school graduation rates.csv",
      #                },
      #                :statewide_testing => {
      #                  :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
      #                  :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
      #                  :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
      #                  :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
      #                  :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      #                }
      #                :economic_profile => {
      #                 :median_household_income => "./data/Median household income.csv",
      #                 :children_in_poverty => "./data/School-aged children in poverty.csv",
      #                 :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
      #                 :title_i => "./data/Title I students.csv"
      #               }
      #              })
  end

  def test_economic_profile_repo_exists
      assert_equal EconomicProfileRepository, @epr.class
  end

  def test_create_open_file_hash
    output = @epr.create_open_file_hash(@fixture_hash[:economic_profile])

    assert output[:median_household_income]
  end

  def test_create_data_hash_dispatcher
    output = @epr.create_open_file_hash(@fixture_hash[:economic_profile])
    result = @epr.create_data_hash_dispatcher(output)
    
    expected = 0.541

    assert_equal expected, result[:math]["COLORADO"][2011][:"hawaiian/pacific_islander"]
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
    expected = ""

    assert_equal expected, result
  end

  def test_load_data_with_fixtures
    @epr.load_data(@fixture_hash)

    expected = 0.541

    ep = @epr.find_by_name("COLORADO")
    assert_equal expected, ep.data[:math][2011][:"hawaiian/pacific_islander"]
  end

  def test_load_district_repository
    district = @dr.find_by_name("ADAMS COUNTY 14")

    economic_profile = district.economic_profile

    assert_equal EconomicProfile, economic_profile.class
  end

end