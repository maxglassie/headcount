require 'minitest/autorun'
require 'minitest/pride'
require './lib/district_repository'
require './lib/headcount_analyst'
require 'pry'

class HeadcountAnalystTest < Minitest::Test

  def setup
    @dr = DistrictRepository.new
    @dr.load_data({
        :enrollment => {
                      :kindergarten => "./data/Kindergartners in full-day program.csv",
                      :high_school_graduation => "./data/High school graduation rates.csv",
                     },
         :economic_profile => {
                      :median_household_income => "./data/Median household income.csv",
                      :children_in_poverty => "./data/School-aged children in poverty.csv",
                      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                      :title_i => "./data/Title I students.csv"
                    }
                                        })
    dr = @dr
    @ha = HeadcountAnalyst.new(dr)
  end

  def test_participation_rate_compares_to_statewide_average
    assert_equal 0.766, @ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  end

  def test_participation_rate_compares_to_another_district
    assert_equal 0.447, @ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')
  end

  def test_participation_rate_variation_trend
    expected = ({2004 => 1.257, 2005 => 0.96, 2006 => 1.05, 2007 => 0.992, 2008 => 0.717, 2009 => 0.652, 2010 => 0.681, 2011 => 0.727, 2012 => 0.688, 2013 => 0.694, 2014 => 0.661 })
    actual = @ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')

    expected.each do |k,v|
      assert_in_delta v, actual[k], 0.005
    end
  end

  def test_kindergarten_participation_compares_to_high_school_graduation
    expected = 0.641
    assert_equal expected, @ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')
  end

  def test_can_identify_result_correlation_is_within_specific_range
    assert_equal true, @ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
  end

  def test_more_than_70_percent_of_districts_show_correlation
    assert_equal true, @ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'STATEWIDE')
  end

  def test_can_calculate_across_a_subset_of_districts
    assert_equal false, @ha.kindergarten_participation_correlates_with_high_school_graduation(:across => ['ACADEMY 20', 'ADAMS COUNTY 14', 'AGUILAR REORGANIZED 6', 'ARICKAREE R-2'])
  end

  def high_poverty_and_high_school_graduation
    #creates high_graduation_high_poverty result set object
  end

  def creates_result_set_object
    #creates result set object
    #asks for two lists
    #one of all result entry objects representing matching districts
    #method - create_result_entry_objects_from_districts
    #one just the result set object that is the statewide average
    #returns result set object
    
    #needs statewide_average_result_set_object
    #needs array of result entry objects
    #asks result set to add data
  end

  def create_result_entry_objects_from_districts
    #make sure to include name
    #takes hash
    #returns array of result entry objects
    #uses district.enrollment.district_average method
    #and assigns to hash
  end

  def create_statewide_average_result_entry_object
    #uses statewide average methods below
  end

  def test_districts_matching_high_poverty_high_school_graduation
    result = @ha.districts_matching_high_poverty_high_school_graduation
    expected = ""

    assert_equal expected, result
  end

  def test_high_poverty_and_high_school_graduation?
    matching_district = @dr.find_by_name("CENTENNIAL R-1")
    non_matching_district = @dr.find_by_name("ACADEMY 20")

    matching_result = @ha.high_poverty_and_high_school_graduation?(matching_district)
    non_matching_result = @ha.high_poverty_and_high_school_graduation?(non_matching_district)

    expected_matching = true
    expected_non_matching = false

    assert_equal expected_matching, matching_result
    assert_equal expected_non_matching, non_matching_result
  end

  def test_free_lunch_above_statewide_average?
    above = @dr.find_by_name("CENTENNIAL R-1")
    below = @dr.find_by_name("ACADEMY 20")

    above_percent = above.economic_profile.free_and_reduced_price_lunch_district_average
    below_percent = below.economic_profile.free_and_reduced_price_lunch_district_average

    above_result = @ha.free_lunch_above_statewide_average?(above)
    above_expected = true

    below_result = @ha.free_lunch_above_statewide_average?(below)
    below_expected = false

    assert_equal above_expected, above_result
    assert_equal below_result, below_expected
  end

  def test_children_in_poverty_above_statewide_average?
    above = @dr.find_by_name("CENTENNIAL R-1")
    below = @dr.find_by_name("ACADEMY 20")

    above_percent = above.economic_profile.children_in_poverty_district_average
    below_percent = below.economic_profile.children_in_poverty_district_average

    above_result = @ha.children_in_poverty_above_statewide_average?(above)
    above_expected = true

    below_result = @ha.children_in_poverty_above_statewide_average?(below)
    below_expected = false

    assert_equal above_expected, above_result
    assert_equal below_result, below_expected
  end

  def test_high_school_graduation_above_statewide_average?
    above = @dr.find_by_name("CENTENNIAL R-1")
    below = @dr.find_by_name("ADAMS-ARAPAHOE 28J")

    above_percent = above.enrollment.high_school_graduation_district_average
    below_percent = below.enrollment.high_school_graduation_district_average

    above_result = @ha.high_school_graduation_above_statewide_average?(above)
    above_expected = true

    below_result = @ha.high_school_graduation_above_statewide_average?(below)
    below_expected = false

    assert_equal above_expected, above_result
    assert_equal below_result, below_expected
  end

  def test_median_income_statewide_average
    expected = 57408
    result = @ha.median_household_income_statewide_average

    assert_equal expected, result
  end

  def test_children_in_poverty_statewide_average
    expected = 0.164
    result = @ha.children_in_poverty_statewide_average

    assert_equal expected, result
  end

  def test_free_and_reduced_price_lunch_statewide_average
    expected = 0.35
    result = @ha.free_and_reduced_price_lunch_statewide_average

    assert_equal expected, result
  end

  def test_high_school_graduation_statewide_average
    expected = 0.751
    result = @ha.high_school_graduation_statewide_average

    assert_equal expected, result
  end


end
