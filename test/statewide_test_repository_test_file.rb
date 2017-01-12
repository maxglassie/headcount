require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment_repository'
require './lib/enrollment'
require './lib/district_repository'
require './lib/statewide_test'
require './lib/statewide_test_repository'

class StatewideTestRepositoryTest < Minitest::Test

  def setup
    @str = StatewideTestRepository.new
    @fixture_hash = {
                      :statewide_testing => {
                        :third_grade => "./test/fixtures/3rd_grade_proficiency_percentage_fixture_COLORADO.csv",
                        :math => "./test/fixtures/race_ethnicity_math_proficiency_COLORADO.csv"
                      }
                    }

    @state_wide_full_hash = {
                    :statewide_testing => {
                      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                    }
                  }

      @dr = DistrictRepository.new
      @dr.load_data({:enrollment => {
                      :kindergarten => "./data/Kindergartners in full-day program.csv",
                      :high_school_graduation => "./data/High school graduation rates.csv",
                     },
                     :statewide_testing => {
                       :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                       :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                       :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                       :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                       :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                     }
                   })
  end

  def test_enrollment_repo_exists
      assert_equal StatewideTestRepository, @str.class
  end

  def test_create_open_file_hash
    output = @str.create_open_file_hash(@fixture_hash[:statewide_testing])

    assert output[:third_grade]
  end

  def test_create_data_hash_dispatcher
    output = @str.create_open_file_hash(@fixture_hash[:statewide_testing])
    result = @str.create_data_hash_dispatcher(output)

    expected = 0.541

    assert_equal expected, result[:math]["COLORADO"][2011][:pacific_islander]
  end

  def test_populate_repository
    output = @str.create_open_file_hash(@fixture_hash[:statewide_testing])
    data_hash = @str.create_data_hash_dispatcher(output)
    @str.populate_repository(data_hash[:third_grade])

    result = @str.find_by_name("Colorado")

    expected = StatewideTest

    assert_equal expected, result.class
  end

  def test_add_data_to_repository_objects
    output = @str.create_open_file_hash(@fixture_hash[:statewide_testing])
    data_hash = @str.create_data_hash_dispatcher(output)
    @str.populate_repository(data_hash[:third_grade])

    @str.add_data_to_repository_objects(:third_grade, data_hash[:third_grade])

    statewide_test = @str.find_by_name("COLORADO")
    result = statewide_test.data[:third_grade]
    expected = {2008=>{:math=>0.697, :reading=>0.703, :writing=>0.501},
                        2009=>{:math=>0.691, :reading=>0.726, :writing=>0.536},
                        2010=>{:math=>0.706, :reading=>0.698, :writing=>0.504},
                        2011=>{:math=>0.696, :reading=>0.728, :writing=>0.513},
                        2012=>{:reading=>0.739, :math=>0.71, :writing=>0.525},
                        2013=>{:math=>0.72295, :reading=>0.73256, :writing=>0.50947},
                        2014=>{:math=>0.71589, :reading=>0.71581, :writing=>0.51072}
                      }

    assert_equal expected, result
  end

  def test_load_data_with_fixtures
    @str.load_data(@fixture_hash)

    expected = 0.541

    st = @str.find_by_name("COLORADO")
    assert_equal expected, st.data[:math][2011][:pacific_islander]
  end

  def test_load_full_data_for_state_wide
    @str.load_data(@state_wide_full_hash)
    statewide = @str.find_by_name("ADAMS COUNTY 14")

    expected = StatewideTest

    assert_equal expected, statewide.class
  end

  def test_load_repository
    district = @dr.find_by_name("ADAMS COUNTY 14")

    statewide = district.statewide_test

    assert_equal StatewideTest, statewide.class
  end

  def test_basic_proficiency_by_grade
      district = @dr.find_by_name("ACADEMY 20")
      statewide = district.statewide_test
      expected = { 2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
                   2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
                   2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
                   2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
                   2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
                   2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
                   2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
                 }

      testing = statewide
      expected.each do |year, data|
        data.each do |subject, proficiency|
          assert_in_delta proficiency, testing.proficient_by_grade(3)[year][subject], 0.005
        end
      end
  end

  def test_basic_proficiency_by_race
    district = @dr.find_by_name("ACADEMY 20")
    statewide = district.statewide_test
    expected = { 2011 => {math: 0.816, reading: 0.897, writing: 0.826},
                 2012 => {math: 0.818, reading: 0.893, writing: 0.808},
                 2013 => {math: 0.805, reading: 0.901, writing: 0.810},
                 2014 => {math: 0.800, reading: 0.855, writing: 0.789},
               }

    result = statewide.proficient_by_race_or_ethnicity(:asian)
    expected.each do |year, data|
      data.each do |subject, proficiency|
        assert_in_delta proficiency, result[year][subject], 0.005
      end
    end
  end

   def test_proficiency_by_subject_and_year
    district = @dr.find_by_name("ACADEMY 20")

    testing = district.statewide_test

    assert_in_delta 0.653, testing.proficient_for_subject_by_grade_in_year(:math, 8, 2011), 0.005

    district_2 = @dr.find_by_name("WRAY SCHOOL DISTRICT RD-2")
    
    testing = district_2.statewide_test
    assert_in_delta 0.89, testing.proficient_for_subject_by_grade_in_year(:reading, 3, 2014), 0.005

    district_3 = @dr.find_by_name("PLATEAU VALLEY 50")
    testing = district_3.statewide_test

    assert_equal "N/A", testing.proficient_for_subject_by_grade_in_year(:reading, 8, 2011)
  end

  def test_proficiency_by_subject_race_and_year
    @str.load_data(@state_wide_full_hash)

    testing = @str.find_by_name("AULT-HIGHLAND RE-9")
    assert_in_delta 0.611, testing.proficient_for_subject_by_race_in_year(:math, :white, 2012), 0.005
    assert_in_delta 0.310, testing.proficient_for_subject_by_race_in_year(:math, :hispanic, 2014), 0.005
    assert_in_delta 0.794, testing.proficient_for_subject_by_race_in_year(:reading, :white, 2013), 0.005
    assert_in_delta 0.278, testing.proficient_for_subject_by_race_in_year(:writing, :hispanic, 2014), 0.005

    testing = @str.find_by_name("BUFFALO RE-4")
    assert_in_delta 0.65, testing.proficient_for_subject_by_race_in_year(:math, :white, 2012), 0.005
    assert_in_delta 0.437, testing.proficient_for_subject_by_race_in_year(:math, :hispanic, 2014), 0.005
    assert_in_delta 0.76, testing.proficient_for_subject_by_race_in_year(:reading, :white, 2013), 0.005
    assert_in_delta 0.375, testing.proficient_for_subject_by_race_in_year(:writing, :hispanic, 2014), 0.005
  end

  def test_unknown_data_errors
    @str.load_data(@state_wide_full_hash)

    testing = @str.find_by_name("AULT-HIGHLAND RE-9")


    assert_raises(UnknownDataError) do
      testing.proficient_by_grade(1)
    end

    assert_raises(UnknownDataError) do
      testing.proficient_for_subject_by_grade_in_year(:pizza, 8, 2011)
    end

    assert_raises(UnknownDataError) do
      testing.proficient_for_subject_by_race_in_year(:reading, :pizza, 2013)
    end

    assert_raises(UnknownDataError) do
      testing.proficient_for_subject_by_race_in_year(:pizza, :white, 2013)
    end
  end

end