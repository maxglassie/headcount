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
                  :kindergarten => "./data/Kindergartners in full-day program.csv"
                                  }
                            })
    @ha = HeadcountAnalyst.new(dr)
  end

  def test_participation_rate_compares_to_statewide_average
    # skip
    assert_equal 0.766, @ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  end

  def test_participation_rate_compares_to_another_district
    # skip
    assert_equal 0.447, @ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')
  end

  def test_participation_rate_variation_trend
    expected = ({2004 => 1.257, 2005 => 0.96, 2006 => 1.05, 2007 => 0.992, 2008 => 0.717, 2009 => 0.652, 2010 => 0.681, 2011 => 0.727, 2012 => 0.688, 2013 => 0.694, 2014 => 0.661 })
    actual = @ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')

    expected.each do |k,v|
      assert_in_delta v, actual[k], 0.005
    end
  end

end