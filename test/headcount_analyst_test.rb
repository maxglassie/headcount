require 'minitest/autorun'
require 'minitest/pride'
require './lib/district_repository'
require './lib/headcount_analyst'
require 'pry'

class HeadcountAnalystTest < Minitest::Test

  def setup
    dr = DistrictRepository.new
    dr.load_data({
        :enrollment => {
                  :kindergarten => "./data/Kindergartners in full-day program.csv",
                  :high_school_graduation => "./data/High school graduation rates.csv"
                                  }
                            })
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

end
