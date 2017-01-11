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
    @load_data_hash = {
                      :statewide_testing => {
                        :third_grade => "./test/fixtures/3rd_grade_proficiency_percentage_fixture_COLORADO.csv",
                        :math => "./test/fixtures/race_ethnicity_math_proficiency_COLORADO.csv"
                      }
                    }

    @load_full_data_hash = {
                    :statewide_testing => {
                      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                    }
                  }
  end

  def test_enrollment_repo_exists
      assert_equal StatewideTestRepository, @str.class
  end

  def test_create_open_file_hash
    output = @str.create_open_file_hash(@load_data_hash[:statewide_testing])

    assert output[:third_grade]
  end

  def test_create_data_hash_dispatcher
    output = @str.create_open_file_hash(@load_data_hash[:statewide_testing])
    result = @str.create_data_hash_dispatcher(output)
    
    expected = 0.541

    assert_equal expected, result[:math]["COLORADO"][2011][:"hawaiian/pacific_islander"]
  end

  def test_populate_repository
    output = @str.create_open_file_hash(@load_data_hash[:statewide_testing])
    data_hash = @str.create_data_hash_dispatcher(output)
    @str.populate_repository(data_hash[:third_grade])

    result = @str.find_by_name("Colorado")

    expected = StatewideTest

    assert_equal expected, result.class
  end

  def test_add_data_to_repository_objects
    output = @str.create_open_file_hash(@load_data_hash[:statewide_testing])
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
  simple = StatewideTestRepository.new
    simple.load_data({
                    :statewide_testing => {
                      :third_grade => "./test/fixtures/3rd_grade_proficiency_percentage_fixture_COLORADO.csv",
                      :math => "./test/fixtures/race_ethnicity_math_proficiency_COLORADO.csv"
                    }
                  })
    simple

  expected = 0.541

  st = simple.find_by_name("COLORADO")
  assert_equal expected, st.data[:math][2011][:"hawaiian/pacific_islander"]
end

def test_load_full_data
  @str.load_data(load_full_data_hash)
  @str.
end

def test_basic_proficiency_by_grade
  skip
    str = statewide_repo
    expected = { 2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
                 2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
                 2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
                 2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
                 2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
                 2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
                 2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
               }

    testing = str.find_by_name("ACADEMY 20")
    expected.each do |year, data|
      data.each do |subject, proficiency|
        assert_in_delta proficiency, testing.proficient_by_grade(3)[year][subject], 0.005
      end
    end
end

def statewide_repo
    str = StatewideTestRepository.new
    str.load_data({
                    :statewide_testing => {
                      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                    }
                  })
    str
  end

  # def district_repo
  #   dr = DistrictRepository.new
  #   dr.load_data({:enrollment => {
  #                   :kindergarten => "./data/Kindergartners in full-day program.csv",
  #                   :high_school_graduation => "./data/High school graduation rates.csv",
  #                  },
  #                  :statewide_testing => {
  #                    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
  #                    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
  #                    :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
  #                    :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
  #                    :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
  #                  }
  #                })
  #   dr
  # end

  # def statewide_repo_fixtures
  #   simple = StatewideTestRepository.new
  #   simple.load_data({
  #                   :statewide_testing => {
  #                     :third_grade => "./test/fixtures/3rd_grade_proficiency_percentage_fixture_COLORADO.csv",
  #                     :math => "./test/fixtures/race_ethnicity_math_proficiency_COLORADO.csv"
  #                   }
  #                 })
  #   simple
  # end

end